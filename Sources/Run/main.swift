import App
import TLS

let config = try Config()
try config.setup()

let drop = try Droplet(config)

try drop.setup()

try drop.run()
