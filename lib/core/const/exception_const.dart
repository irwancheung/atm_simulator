// login
const loginInvalidParams = 'Login failed. Invalid or insufficient parameters.';
const loginInvalidUsername =
    'Login failed. Username cannot contain spaces and special characters.';
const loginUsernameLength = 'Login failed. Username must be 3-10 characters.';
const loginPinMustNumeric = 'Login failed. PIN must be a number.';
const loginPinMustSixDigits = 'Login failed. PIN must be 6 digits.';
const loginAlreadyLoggedIn = 'Login failed. Customer already logged in.';
const loginPinNotMatch = 'Login failed. PIN is not match.';

// logout
const logoutAlreadyLoggedOut = 'Logout failed. Customer already logged out.';

// checkBalance
const balanceNotLoggedIn = 'Check balance failed. Customer not logged in.';

// Deposit
const depositNotLoggedIn = 'Deposit failed. Customer not logged in.';
const depositInvalidParams =
    'Deposit failed. Invalid or insufficient parameters.';
const depositInvalidAmount =
    'Deposit failed. Amount must be a positive number.';

// Withdraw
const withdrawNotLoggedIn = 'Withdraw failed. Customer not logged in.';
const withdrawInvalidParams =
    'Withdraw failed. Invalid or insufficient parameters.';
const withdrawInvalidAmount =
    'Withdraw failed. Amount must be a positive number.';
const withdrawInsufficientBalance = 'Withdraw failed. Insufficient balance.';

// Transfer
const transferNotLoggedIn = 'Transfer failed. Customer not logged in.';
const transferInvalidParams =
    'Transfer failed. Invalid or insufficient parameters.';
const transferInvalidAmount =
    'Transfer failed. Amount must be a positive number.';
const transferInsufficientBalance = 'Transfer failed. Insufficient balance.';
const transferTargetNotFound = 'Transfer failed. Target customer not found.';
const transferSameAccount = 'Transfer failed. Cannot transfer to same account.';

// Command failed
const loginCommandFailed = 'Failed to execute login command.';
const logoutCommandFailed = 'Failed to execute logout command.';
const balanceCommandFailed = 'Failed to execute balance command.';
const depositCommandFailed = 'Failed to execute deposit command.';
const withdrawCommandFailed = 'Failed to execute withdraw command.';
const transferCommandFailed = 'Failed to execute transfer command.';
const helpCommandFailed = 'Failed to execute help command.';
const clearCommandFailed = 'Failed to execute clear command.';
const unknownCommand = 'Unknown command. Type "help" for a list of commands.';
