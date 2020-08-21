BATTERY=0

BATTERY_INFO=$(acpi -b | grep "Battery ${BATTERY}")
BATTERY_STATE=$(echo "${BATTERY_INFO}" | grep -wo "Full\|Charging\|Discharging")
BATTERY_POWER=$(echo "${BATTERY_INFO}" | grep -o '[0-9]\+%' | tr -d '%')

URGENT_VALUE=10

discharging_icons=" "
charging_icons=" "

index=$(($BATTERY_POWER / 10))

icons=$discharging_icons
if [[ "${BATTERY_STATE}" = "Charging" ]]; then
  icons=$charging_icons
fi

icon=${icons:$index:1}
text="${icon} ${BATTERY_POWER}%"

echo $text
echo $text

if [[ "${BATTERY_POWER}" -le "${URGENT_VALUE}" ]]; then
  exit 33
fi

