# Bugsnag Paperpile fork

This is a fork of [bugsnag-js](https://github.com/bugsnag/bugsnag-js) needed for the `desktop` project.

- It contains prebuilt Electron binaries for Mac and Windows (created by [prebuild](https://github.com/prebuild/prebuild)). It uses [prebuild-install](https://github.com/prebuild/prebuild-install) so `electron-builder` can automatically pick up the prebuilt binaries. Thanks to that, we can build for both platforms from a Mac.
- It fixes `ERR_TUNNEL_CONNECTION_FAILED` uncaught error, happening when using a proxy that requires credentials but the credentials are incorrect or not set in the OS. The uncaught error led to showing the "Unexpected error" modal in `desktop`.
- It serializes our custom errors, when sending them from the renderer process through IPC. That way we can log more info, such as `error.cause`.

## Quick start
- To start the project, follow the [Development quick start](#development-quick-start).
- To add a package, use `lerna`, e.g add `nan` to two sub-packages:
```
npx lerna add nan --scope @bugsnag/plugin-electron-app --scope @bugsnag/plugin-electron-client-state-persistence
```
- To build native packages, do this and then commit to git:
```
cd ./packages/plugin-electron-app && npm run prebuild && cd -
cd ./packages/plugin-electron-client-state-persistence && npm run prebuild && cd -
```

# Bugsnag error monitoring & reporting for JavaScript

Automatically detect JavaScript errors in the browser, Node.js, React Native and Expo, with plugins for React, Vue, Angular, Express, Restify and Koa. Get cross-platform error detection for handled and unhandled errors with real-time error alerts and detailed diagnostic reports.

Learn more about [JavaScript error reporting](https://www.bugsnag.com/platforms/javascript/) and [React Native error reporting](https://www.bugsnag.com/platforms/react-native-error-reporting/) from Bugsnag.

---

This is a monorepo (managed with [Lerna](https://lerna.js.org/) containing our universal error reporting client [`@bugsnag/js`](/packages/js), our Expo client [`@bugsnag/expo`](/packages/expo) and our React Native client [`@bugsnag/react-native`](/packages/react-native), along with:

- the core Bugsnag libraries for reporting errors ([`@bugsnag/core`](/packages/core))
- plugins for supporting various frameworks (e.g. [`@bugsnag/plugin-react`](/packages/plugin-react))
- plugins for internal functionality (e.g. [`@bugsnag/plugin-simple-throttle`](/packages/plugin-simple-throttle))

Etc. See [packages](/packages) for a full list of contents.

## Getting started

1. [Create a Bugsnag account](https://www.bugsnag.com)
2. Complete the instructions in the [integration guide](https://docs.bugsnag.com/platforms/javascript/)
3. Report handled exceptions using
   [`Bugsnag.notify()`](https://docs.bugsnag.com/platforms/javascript/#reporting-handled-exceptions)
4. Customize your integration using the
   [configuration options](https://docs.bugsnag.com/platforms/javascript/configuration-options/)

## Integrating with frameworks

Use the following plugins and guides to integrate Bugsnag with various frameworks.

### Browser

| Framework  | Bugsnag plugin | Documentation |
| ---------- | -------------- | --------------|
| Vue | [@bugsnag/plugin-vue](packages/plugin-vue) | [Vue docs](https://docs.bugsnag.com/platforms/javascript/vue)
| React | [@bugsnag/plugin-react](packages/plugin-react) | [React docs](https://docs.bugsnag.com/platforms/javascript/react)
| Angular | [@bugsnag/plugin-angular](packages/plugin-angular) | [Angular docs](https://docs.bugsnag.com/platforms/javascript/angular)

### Desktop

| Framework  | Bugsnag notifier | Documentation |
| ---------- | ---------------- | --------------|
| Electron   | [@bugsnag/electron](packages/electron) | [Electron docs](https://docs.bugsnag.com/platforms/electron) |

### Server

| Framework  | Bugsnag plugin | Documentation |
| ---------- | -------------- | --------------|
| Koa | [@bugsnag/plugin-koa](packages/plugin-koa)  | [Koa docs](https://docs.bugsnag.com/platforms/javascript/koa) |
| Express | [@bugsnag/plugin-express](packages/plugin-express)  | [Express docs](https://docs.bugsnag.com/platforms/javascript/express) |
| Restify | [@bugsnag/plugin-restify](packages/plugin-restify)  | [Restify docs](https://docs.bugsnag.com/platforms/javascript/restify) |

### Mobile

| Framework  | Bugsnag notifier | Documentation |
| ---------- | -------------- | --------------|
| Expo | [@bugsnag/expo](packages/expo)  | [Expo docs](https://docs.bugsnag.com/platforms/react-native/expo/) |
| React Native | [@bugsnag/react-native](packages/react-native) | [React Native docs](https://docs.bugsnag.com/platforms/react-native/react-native/) |

## Support

* Check out the [FAQ](https://docs.bugsnag.com/platforms/javascript/faq) and [configuration options](https://docs.bugsnag.com/platforms/javascript/configuration-options)
* [Search open and closed issues](https://github.com/bugsnag/bugsnag-js/issues?q=+) for similar problems
* [Report a bug or request a feature](https://github.com/bugsnag/bugsnag-js/issues/new/choose)

## Contributing

Most updates to this repo will be made by Bugsnag employees. We are unable to accommodate significant external PRs such as features additions or any large refactoring, however minor fixes are welcome. See [contributing](CONTRIBUTING.md) for more information.

## Development quick start

```sh
# Clone the repository
git clone git@github.com:bugsnag/bugsnag-js.git
cd bugsnag-js

# Install top-level dependencies
npm i

# Bootstrap all of the packages
npm run bootstrap

# Build the standalone notifiers and plugins
npm run build

# Run the unit tests
npm run test:unit

# Run tests for a specific package
npm run test:unit -- --testPathPattern="packages/react-native"

# Generate a code coverage report
npm run test:unit -- --coverage

# Run the linter
npm run test:lint

# Run the typescript compatibility tests
npm run test:types
```

See [contributing](CONTRIBUTING.md) for more information.

## License

All packages in this repository are released under the MIT License. See [LICENSE.txt](./LICENSE.txt) for details.
