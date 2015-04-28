import json
import os

from steinie import Steinie

from . import Kernel

app = Steinie()
k = Kernel(os.getcwd())


@app.post("/")
def handler(request, response):
    submitted = request.get_data()
    ret = k.execute(submitted)
    return json.dumps(ret)

try:
    app.run()
except KeyboardInterrupt:
    kernel.terminate()
