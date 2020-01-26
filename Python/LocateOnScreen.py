import sys
import pyautogui

if (len(sys.argv) != 3):
    print("Expected 2 argument got: " + str(len(sys.argv)))
    print(sys.argv)
    sys.exit(2)

print("SubImage: " + sys.argv[1])
print("Confidence: " + sys.argv[2])

conf = float(sys.argv[2])

result = pyautogui.locateOnScreen(sys.argv[1], confidence=conf)

if (result == None):
    print(False)
    sys.exit(1)
else:
    print(result)
    print(True)
    sys.exit(0)
