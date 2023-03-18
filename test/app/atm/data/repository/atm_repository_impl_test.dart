import 'atm_repository_impl_check_balance_test.dart' as check_balance_test;
import 'atm_repository_impl_clear_commands_test.dart' as clear_commands_test;
import 'atm_repository_impl_deposit_test.dart' as deposit_test;
import 'atm_repository_impl_log_in_test.dart' as log_in_test;
import 'atm_repository_impl_log_out_test.dart' as log_out_test;
import 'atm_repository_impl_show_help_test.dart' as show_help_test;
import 'atm_repository_impl_transfer_test.dart' as transfer_test;
import 'atm_repository_impl_withdraw_test.dart' as withdraw_test;

void main() {
  log_in_test.main();
  log_out_test.main();
  check_balance_test.main();
  deposit_test.main();
  withdraw_test.main();
  transfer_test.main();
  clear_commands_test.main();
  show_help_test.main();
}
