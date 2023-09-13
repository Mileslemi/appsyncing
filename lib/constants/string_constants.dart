const String emailValidationPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+$";
//this below regex validates without a .something end e.g., miles@localhost
//r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
const String phoneNoValidationPattern = r"^(?:[+0])[0-9]{9,16}$";

const String positiveNumericValuePattern = r"^[0-9]+([.][0-9]+)?$";

const String apiUsername = "ck_e42a54fb75e8c52894547034e190c566fb3cad96";
const String apiPassword = "cs_d9adc62d6af04b8aea0cc17b356796cc148bdec7";

const String myApiBaseUrl = "https://smashfit.pythonanywhere.com";
