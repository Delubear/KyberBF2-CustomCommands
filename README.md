# KyberBF2-CustomCommands
A few useful commands for running your own private Kyber server.

Currently requires your server module to be `ver/beta10`
- In Kyber launcher, go to Update and change the Target Service to "Kyber-module" and change the release channel to `ver/beta10`
- Add this environment variable to your container:  `KYBER_MODULE_CHANNEL: "ver/beta10"`
- Mount this volume to your container:  `"C:/ProgramData/Kyber/Module:/root/.local/share/kyber/module"`
