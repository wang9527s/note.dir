
```bash
pip install opencv-python ffmpeg
pip install pillow
pip install numpy
pip install scikit-learn
pip install lmdb
pip install matplotlib
pip install paddleocr

# 注意版本
python3 -m pip install paddlepaddle==3.0.0 --break-system-packages -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
```

```py
python SubtitleExtractor.py zimu.mp4 60 800 950
```

```py
import cv2
import os
import sys
from paddleocr import PaddleOCR
import numpy as np

if len(sys.argv) < 4:
    print("example:")
    print("script.py <file> <帧率> <y1> <y2>")
    sys.exit(1)

filename = sys.argv[1]
frame_rate = int(sys.argv[2])  # 每多少帧处理一次
rect_y1 = int(sys.argv[3])  # 字幕区域的起始 y 值
rect_y2 = int(sys.argv[4])  # 字幕区域的结束 y 值


print(f"params: file {filename}, fps {frame_rate}, 字幕区域y值 [{rect_y1}, {rect_y2}]")

ocr = PaddleOCR(
    use_doc_orientation_classify=False,
    use_doc_unwarping=False,
    use_textline_orientation=False
)

cap = cv2.VideoCapture(filename, cv2.CAP_FFMPEG)  # 尝试使用 FFmpeg 解码器

merge_img = None
subtitle_above_region = None
subtitle_below_region = None
subtitle_regions = []  # 存储提取的字幕区域

# 追加拼接函数
def append_to_bottom(existing_img, new_img):
    """
    将新的图像追加到现有图像的下方
    
    :param existing_img: 当前已有的图像
    :param new_img: 需要添加的新图像
    :return: 拼接后的新图像
    """
    if existing_img is None:
        return new_img  # 如果现有图像为空，直接返回新的图像
    return cv2.vconcat([existing_img, new_img])  # 使用 OpenCV 的 vconcat 拼接图像

frame_count = 0
while True:
    ret, frame = cap.read()
    if not ret:
        break
    frame_count += 1
    if frame_count % frame_rate != 0:  # 每frame_rate帧处理一次
        continue

    # 使用 PaddleOCR 进行文本识别
    result = ocr.predict(frame, use_textline_orientation=False)  # 开启文本方向分类
    img_pathname = f'frame_{frame_count}.png'
    cv2.imwrite(img_pathname, frame)

    result = ocr.predict(input=img_pathname)
    per_texts = []
    img = frame

    # 处理识别结果，提取字幕区域
    for res in result:
        texts = []
        for i in range(len(res["rec_texts"])):
            text = res["rec_texts"][i]  # 识别出的文本
            box = res["rec_boxes"][i]  # 对应的矩形框坐标

            # 如果识别出的文本框在指定矩形区域内
            x1, y1, x2, y2 = box
            if rect_y1 <= y1 and rect_y2 >= y2:
                texts.append(text)
                # cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)

        if per_texts == texts:
            continue
        per_texts = texts
        print(f"OCR text, in {frame_count} frame: {texts}")

        # 处理识别到的帧
        if merge_img is None:
            merge_img = frame
            # 提取字幕区域的上方和下方部分
            subtitle_above_region = frame[0:rect_y1, 0:frame.shape[1]] 
            subtitle_below_region = frame[rect_y2:frame.shape[0], 0:frame.shape[1]] 
            # 保存上方和下方区域（调试用）
            cv2.imwrite("subtitle_above_region.png", subtitle_above_region)
            cv2.imwrite("subtitle_below_region.png", subtitle_below_region)
        
        subtitle_regions.append(frame[rect_y1:rect_y2, :]) 
        
        os.remove(img_pathname)


cap.release()

final_subtitles = None
for region in subtitle_regions:
    final_subtitles = append_to_bottom(final_subtitles, region)

# 合成最终图像：字幕上方区域 + 拼接后的字幕区域 + 字幕下方区域
final_image = append_to_bottom(subtitle_above_region, final_subtitles)
final_image = append_to_bottom(final_image, subtitle_below_region)

# 保存最终合成的图像
cv2.imwrite("final_image.png", final_image)
print("合成图像已保存为 final_image.png")

```