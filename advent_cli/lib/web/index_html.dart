part of "server.dart";

const _indexHtml = '''
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AOC Token</title>
</head>

<style>
    body {
        height: 100vh;
        width: 100%;
    }

    .flex--column--center {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }
</style>

<body class="flex--column--center">
    <h1>Submit your session token here!</h1>
    <form action="callback?" method="get">
        <input name="session" />
        <button>Submit</button>
    </form>
</body>

</html>
''';
