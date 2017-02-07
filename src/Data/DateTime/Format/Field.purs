module Data.DateTime.Format.Field
where

import Prelude
import Data.Generic

data HoursStyle
  = Hours12
  | Hours24

derive instance genericHoursStyle :: Generic HoursStyle

instance showHoursStyle :: Show HoursStyle where
  show = gShow

derive instance eqHoursStyle :: Eq HoursStyle


data Padding
  = NoPadding
  | PadWith Char

derive instance genericPadding :: Generic Padding

instance showPadding :: Show Padding where
  show = gShow

derive instance eqPadding :: Eq Padding

data Abbreviated
  = Abbreviated
  | Full

derive instance genericAbbreviated :: Generic Abbreviated

instance showAbbreviated :: Show Abbreviated where
  show = gShow

derive instance eqAbbreviated :: Eq Abbreviated

data TimeField
  = HoursField HoursStyle Padding
  | MinutesField Padding
  | SecondsField Padding
  | MillisecondsField
  | AMPMField

derive instance genericTimeField :: Generic TimeField

instance showTimeField :: Show TimeField where
  show = gShow

derive instance eqTimeField :: Eq TimeField

data DateField
  = YearField Abbreviated Padding
  | MonthNumberField Padding
  | MonthNameField Abbreviated
  | DayOfMonthField Padding
  | WeekdayField Abbreviated

derive instance genericDateField :: Generic DateField

instance showDateField :: Show DateField where
  show = gShow

derive instance eqDateField :: Eq DateField

data DateTimeField
  = TimeField TimeField
  | DateField DateField

derive instance genericDateTimeField :: Generic DateTimeField

instance showDateTimeField :: Show DateTimeField where
  show = gShow

derive instance eqDateTimeField :: Eq DateTimeField
