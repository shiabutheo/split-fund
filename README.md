Introduced the initial version of the `split-fund` smart contract designed to automate STX fund distribution among multiple recipients. This contract allows a sender to specify recipients and their percentage shares, and automatically splits incoming STX accordingly.

 Key Features:
- Added functionality to configure a list of recipients and their respective split percentages.
- Implemented logic to validate that total percentages equal 100.
- Added a public function to trigger STX splitting based on the current configuration.
- Includes read-only functions to inspect recipient shares.

 Purpose:
This contract facilitates use cases such as:
- Revenue sharing between team members
- Decentralized profit distribution
- Automated royalty or donation splitting

 Future Improvements:
- Add support for dynamic recipient updates by contract owner.
- Extend support for SIP-010 token splits.
- Add event logs for split transactions.
