# Define the Pester test block
Describe 'Windows Server UK Configuration' {

    # Test the Time Zone
    It 'Should have the correct time zone set to UK time zone' {
        $timeZone = Get-TimeZone
        $expectedTimeZones = @('GMT Standard Time', 'GMT Daylight Time')
        $expectedTimeZones -contains $timeZone.Id | Should -Be $true
    }

    # Test the System Locale
    It 'Should have the system locale set to en-GB' {
        $systemLocale = Get-WinSystemLocale
        $systemLocale.Name | Should -Be 'en-GB'
    }

    # Test the Input Language
    It 'Should have the input language set to en-GB' {
        $inputLanguage = Get-WinUserLanguageList
        $inputLanguage[0].LanguageTag | Should -Be 'en-GB'
    }

    # Test the Currency Format
    It 'Should have the currency format set to £' {
        $currencySymbol = (Get-Culture).NumberFormat.CurrencySymbol
        $currencySymbol | Should -Be '£'
    }

    # Test the Date Format
    It 'Should have the short date pattern set to dd/MM/yyyy' {
        $dateFormat = (Get-Culture).DateTimeFormat.ShortDatePattern
        $dateFormat | Should -Be 'dd/MM/yyyy'
    }

    # Test the Time Format
    It 'Should have the time format set to HH:mm:ss' {
        $timeFormat = (Get-Culture).DateTimeFormat.LongTimePattern
        $timeFormat | Should -Be 'HH:mm:ss'
    }

}

