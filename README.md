# auth0

A new Flutter library for Poeta Digital can apply Auth0 as soon as possible.

## Usage

`auth0_client` has a narrow and user-friendly API.

See the `auth0_example` for additional examples.

For example initial auth0_client with a method:
```dart
const AUTH0_DOMAIN = 'dev-mpl7u4pn.auth0.com';
const AUTH0_CLIENT_ID = 'Fg52qlqEGpvTp8C0RvUVk3x5ZHoQMu0q';
const AUTH0_REDIRECT_URI = 'com.poetadigital.auth0://callback';

void main() {
  Auth0Client.initial(AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI);
  runApp(MyApp());
}
```

How to integrate Login Api to project 
```dart
Future<void> loginAction() async {
    try {
      final decodedToken = await Auth0Client.login();
      setState(() {
        isLoggedIn = true;
        name = decodedToken['name'];
        picture = decodedToken['picture'];
      });
    } catch (e) {
      setState(() {
              isLoggedIn = false;
              errorMessage = e.toString();
            });
    }
  }
```

How to integrate Logout Api to project
```dart
void logoutAction() async {
    await Auth0Client.logout();
    setState(() {
      isLoggedIn = false;
    });
  }
```

## Contributing

* Read and help us document common patterns over [at the wiki][wiki].
* Is there a *bug* in the code? [File an issue][issue].

[wiki]: https://github.com/andoutica/poeta_auth0_client/wiki
[issue]: https://github.com/andoutica/poeta_auth0_client/issues
