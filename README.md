# Custom winapps tutorial

This is a custom winapps tutorial that I created for a friend.

This uses the winapps-org winapps project [winapps github](https://github.com/winapps-org/winapps)

This project includes a node server that provides a written tutorial for setting up winapps on a linux machine, and a
convenience script to help set up the VM on the local machine via docker.

The tutorial can be found at [https://wai.gladiatorsas.me](https://wai.gladiatorsas.me) or you can run it locally by
cloning this repository and running the `npm install` then either `npm start` or `npm run dev` to start the server, and
then navigating to `http://localhost:3000` in your web browser.

This can also be run in a docker container by running the `docker-compose up` command in the root of the repository.
This will build the image and start the server and make it available at `http://localhost:3000`.

If there are any issues with the tutorial, please open an issue on this repository.