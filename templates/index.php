<?php ?>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>LEMP Webserver</title>

    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Barlow+Semi+Condensed" rel="stylesheet">

    <style>
        html body {
            font-size: 16px;
            font-family: 'Roboto', sans-serif;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Barlow Semi Condensed', sans-serif;            
        }

        .container {
            display: flex;
            justify-content: center;
            flex-direction: column;
            align-items: center;
            margin: 1rem;
            width: 100%;
        }

        .title {
            font-size: 4rem;
            margin: 1rem;
        }

        .contribute,
        .contribute:active,
        .contribute:visited,
        .contribute:link {
            color: #333;
            cursor: pointer;
            text-decoration: none;
            outline: none;
        }

        .contribute:hover {
            color: #444;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="title"> 
            - LEMP Webserver -
        </h1>
        <a href="https://github.com/alexmdodge/lemp-configuration" class="contribute">
            Your site is configured and ready to go!
        </a>
    </div>
    <?php phpinfo(); ?>
</body>
</html>