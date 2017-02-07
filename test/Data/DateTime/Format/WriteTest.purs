module Data.DateTime.Format.WriteTest
where

import Prelude
import Test.Unit (TestSuite, Test, test, suite, failure)
import Test.Unit.Assert (assert)
import Test.Unit.Assert as Assert
import Data.Array as Array
import Data.Either (Either (..))
import Data.Maybe (Maybe (..), fromMaybe)
import Data.Enum (toEnum)
import Data.DateTime.Format
import Data.Date (canonicalDate, Month (..), Year, Day)
import Data.Time (Time (..), Hour, Minute, Second, Millisecond)

mkYear :: Int -> Year
mkYear = toEnum >>> fromMaybe bottom

mkDay :: Int -> Day
mkDay = toEnum >>> fromMaybe bottom

writerSuite :: forall e. TestSuite e
writerSuite = do
  dateWriterSuite
  timeWriterSuite

timeWriterSuite :: forall e. TestSuite e
timeWriterSuite =
  suite "Time Writer" do
      test "empty format string" do
        let expected = Just ""
            actual =
              writeTimeFormat
                []
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "hour (24-based)" do
        let expected = Just "13"
            actual =
              writeTimeFormat
                [FormatItem $ HoursField Hours24 NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "hour (12-based)" do
        let expected = Just "1"
            actual =
              writeTimeFormat
                [FormatItem $ HoursField Hours12 NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "hour (12-based, 0-padded)" do
        let expected = Just "01"
            actual =
              writeTimeFormat
                [FormatItem $ HoursField Hours12 (PadWith '0')]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "hour (12-based, am/pm)" do
        let expected = Just "1PM"
            actual =
              writeTimeFormat
                [ FormatItem $ HoursField Hours12 NoPadding
                , FormatItem $ AMPMField
                ]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "minute (> 9)" do
        let expected = Just "37"
            actual =
              writeTimeFormat
                [FormatItem $ MinutesField NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "minute (<= 9)" do
        let expected = Just "4"
            actual =
              writeTimeFormat
                [FormatItem $ MinutesField NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 4
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "minute (<= 9, 0-padded)" do
        let expected = Just "04"
            actual =
              writeTimeFormat
                [FormatItem $ MinutesField (PadWith '0')]
                <$> (Time <$> toEnum 13
                          <*> toEnum 4
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "second (> 9)" do
        let expected = Just "23"
            actual =
              writeTimeFormat
                [FormatItem $ SecondsField NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "second (<= 9)" do
        let expected = Just "4"
            actual =
              writeTimeFormat
                [FormatItem $ SecondsField NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 4
                          <*> toEnum 456)
        Assert.equal expected actual

      test "second (<= 9, 0-padded)" do
        let expected = Just "04"
            actual =
              writeTimeFormat
                [FormatItem $ SecondsField (PadWith '0')]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 4
                          <*> toEnum 456)
        Assert.equal expected actual

      test "millisecond (> 9)" do
        let expected = Just "456"
            actual =
              writeTimeFormat
                [FormatItem $ MillisecondsField NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 456)
        Assert.equal expected actual

      test "millisecond (<= 9)" do
        let expected = Just "4"
            actual =
              writeTimeFormat
                [FormatItem $ MillisecondsField NoPadding]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 4)
        Assert.equal expected actual

      test "millisecond (<= 9, 0-padded)" do
        let expected = Just "004"
            actual =
              writeTimeFormat
                [FormatItem $ MillisecondsField (PadWith '0')]
                <$> (Time <$> toEnum 13
                          <*> toEnum 37
                          <*> toEnum 23
                          <*> toEnum 4)
        Assert.equal expected actual


dateWriterSuite :: forall e. TestSuite e
dateWriterSuite =
    suite "Date Writer" do
      test "empty format string" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = ""
            actual = writeDateFormat [] sampleDate
        Assert.equal expected actual

      test "full year" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = "2017"
            actual =
              writeDateFormat
                [FormatItem $ YearField Full NoPadding]
                sampleDate
        Assert.equal expected actual

      test "abbreviated year" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = "17"
            actual =
              writeDateFormat
                [FormatItem $ YearField Abbreviated NoPadding]
                sampleDate
        Assert.equal expected actual

      -- -- The following test does not currently pass, because of a bug in the
      -- -- purescript-datetime library that makes it impossible to lawfully
      -- -- create date values before 1900. Unfortunately, we need such dates
      -- -- in order to test the unpadded year number feature, which requires
      -- -- year numbers smaller than 10, or at least smaller than 1000.
      -- --
      -- -- For reference:
      -- -- https://github.com/purescript/purescript-datetime/issues/46
      -- test "full year, not padded" do
      --   let sampleDate = canonicalDate (mkYear 1) March (mkDay 15)
      --       expected = "1"
      --       actual =
      --         writeDateFormat
      --           [FormatItem $ YearField Full NoPadding]
      --           sampleDate
      --   Assert.equal expected actual

      test "full month name" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = "March"
            actual =
              writeDateFormat
                [FormatItem $ MonthNameField Full]
                sampleDate
        Assert.equal expected actual

      test "short month name" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = "Mar"
            actual =
              writeDateFormat
                [FormatItem $ MonthNameField Abbreviated]
                sampleDate
        Assert.equal expected actual

      test "full month number" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = "03"
            actual =
              writeDateFormat
                [FormatItem $ MonthNumberField (PadWith '0')]
                sampleDate
        Assert.equal expected actual

      test "month number, space padded" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = " 3"
            actual =
              writeDateFormat
                [FormatItem $ MonthNumberField (PadWith ' ')]
                sampleDate
        Assert.equal expected actual

      test "short month number" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 15)
            expected = "3"
            actual =
              writeDateFormat
                [FormatItem $ MonthNumberField NoPadding]
                sampleDate
        Assert.equal expected actual

      test "full day number" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 5)
            expected = "05"
            actual =
              writeDateFormat
                [FormatItem $ DayField (PadWith '0')]
                sampleDate
        Assert.equal expected actual

      test "full day number (> 9)" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 12)
            expected = "12"
            actual =
              writeDateFormat
                [FormatItem $ DayField (PadWith '0')]
                sampleDate
        Assert.equal expected actual

      test "day number, space padded" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 5)
            expected = " 5"
            actual =
              writeDateFormat
                [FormatItem $ DayField (PadWith ' ')]
                sampleDate
        Assert.equal expected actual

      test "short day number" do
        let sampleDate = canonicalDate (mkYear 2017) March (mkDay 5)
            expected = "5"
            actual =
              writeDateFormat
                [FormatItem $ DayField NoPadding]
                sampleDate
        Assert.equal expected actual

      test "full weekday name" do
        let sampleDate = canonicalDate (mkYear 2017) February (mkDay 7)
            expected = "Tuesday"
            actual =
              writeDateFormat
                [FormatItem $ WeekdayField Full]
                sampleDate
        Assert.equal expected actual

      test "short weekday name" do
        let sampleDate = canonicalDate (mkYear 2017) February (mkDay 7)
            expected = "Tue"
            actual =
              writeDateFormat
                [FormatItem $ WeekdayField Abbreviated]
                sampleDate
        Assert.equal expected actual
