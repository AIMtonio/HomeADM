DELIMITER ;
DROP FUNCTION IF EXISTS FNLIMPIACARACTERESXML;

DELIMITER $$
CREATE FUNCTION FNLIMPIACARACTERESXML(

	Par_Texto 			VARCHAR(2000)

) RETURNS varchar(2000) CHARSET latin1
    DETERMINISTIC
BEGIN


	DECLARE Var_Resultado 		VARCHAR(2000);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Con_Ampersa			CHAR(1);
	DECLARE Con_SignoMenor		CHAR(1);
	DECLARE Con_SignoMayor		CHAR(1);
	DECLARE Con_ComillaSimple	CHAR(1);
	DECLARE Con_ComillaDoble	CHAR(1);
    DECLARE Con_ATilde			CHAR(1);
    DECLARE Con_ATildeMinu		CHAR(1);
    DECLARE Con_ETilde			CHAR(1);
    DECLARE Con_ETildeMinu		CHAR(1);
    DECLARE Con_ITilde			CHAR(1);
    DECLARE Con_ITildeMinu		CHAR(1);
    DECLARE Con_OTilde			CHAR(1);
    DECLARE Con_OTildeMinu		CHAR(1);
    DECLARE Con_UTilde			CHAR(1);
    DECLARE Con_UTildeMinu		CHAR(1);
	DECLARE Con_UDieresis		CHAR(1);
	DECLARE Con_UDieresisMinu	CHAR(1);
    DECLARE Con_NTildeMayu		CHAR(1);
    DECLARE Con_NTildeMinu		CHAR(1);
    DECLARE Con_caracterInvi	CHAR(2);
	DECLARE Con_CadAmpersa			CHAR(6);
	DECLARE Con_CadSignoMenor		CHAR(6);
	DECLARE Con_CadSignoMayor		CHAR(6);
	DECLARE Con_CadComillaSimple	CHAR(6);
	DECLARE Con_CadComillaDoble		CHAR(6);
    DECLARE Con_CadATilde			CHAR(8);
    DECLARE Con_CadATildeMinu		CHAR(8);
    DECLARE Con_CadETilde			CHAR(8);
    DECLARE Con_CadETildeMinu		CHAR(8);
    DECLARE Con_CadITilde			CHAR(8);
    DECLARE Con_CadITildeMinu		CHAR(8);
    DECLARE Con_CadOTilde			CHAR(8);
    DECLARE Con_CadOTildeMinu		CHAR(8);
    DECLARE Con_CadUTilde			CHAR(8);
    DECLARE Con_CadUTildeMinu		CHAR(8);
	DECLARE Con_CadUDieresis		CHAR(8);
	DECLARE Con_CadUDieresisMinu	CHAR(8);
    DECLARE Con_CadNTildeMayu		CHAR(8);
    DECLARE Con_CadNTildeMinu		CHAR(8);


	SET Cadena_Vacia		:= '';
	SET Con_Ampersa			:= '&';
	SET Con_SignoMenor		:= '<';
	SET Con_SignoMayor		:= '>';
	SET Con_ComillaSimple	:= "'";
	SET Con_ComillaDoble	:= '"';
    SET Con_ATilde			:= 'Á';
    SET Con_ATildeMinu		:= 'á';
	SET Con_ETilde			:= 'É';
	SET Con_ETildeMinu		:= 'é';
	SET Con_ITilde			:= 'Í';
	SET Con_ITildeMinu		:= 'í';
	SET Con_OTilde			:= 'Ó';
	SET Con_OTildeMinu		:= 'ó';
	SET Con_UTilde			:= 'Ú';
	SET Con_UTildeMinu		:= 'ú';
	SET Con_UDieresis		:= 'Ü';
	SET Con_UDieresisMinu	:= 'ü';
	SET Con_NTildeMayu		:= 'Ñ';
	SET Con_NTildeMinu		:= 'ñ';
    SET Con_caracterInvi	:=' ';

	SET Con_CadAmpersa			:= '&amp;';
	SET Con_CadSignoMenor		:= '&lt;';
	SET Con_CadSignoMayor		:= '&gt;';
	SET Con_CadComillaSimple	:= '&apos;';
	SET Con_CadComillaDoble		:= '&quot;';
    SET Con_CadATilde			:= '&#193;';
    SET Con_CadATildeMinu		:= '&#225;';
	SET Con_CadETilde			:= '&#201;';
    SET Con_CadETildeMinu		:= '&#233;';
	SET Con_CadITilde			:= '&#205;';
    SET Con_CadITildeMinu		:= '&#237;';
	SET Con_CadOTilde			:= '&#211;';
    SET Con_CadOTildeMinu		:= '&#243;';
	SET Con_CadUTilde			:= '&#218;';
    SET Con_CadUTildeMinu		:= '&#250;';
	SET Con_CadUDieresis		:= '&#220;';
    SET Con_CadUDieresisMinu	:= '&#252;';
	SET Con_CadNTildeMayu		:= '&#209;';
	SET Con_CadNTildeMinu		:= '&#241;';

	SET Par_Texto 			:= IFNULL(Par_Texto,Cadena_Vacia);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_Ampersa,		Con_CadAmpersa);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_SignoMenor,	Con_CadSignoMenor);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_SignoMayor,	Con_CadSignoMayor);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ComillaSimple,Con_CadComillaSimple);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ComillaDoble,	Con_CadComillaDoble);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ATilde,	Con_CadATilde);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ATildeMinu,	Con_CadATildeMinu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ETilde,	Con_CadETilde);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ETildeMinu,	Con_CadETildeMinu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ITilde,	Con_CadITilde);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ITildeMinu,	Con_CadITildeMinu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_OTilde,	Con_CadOTilde);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_OTildeMinu,	Con_CadOTildeMinu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_UTilde,	Con_CadUTilde);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_UTildeMinu,	Con_CadUTildeMinu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_UDieresis,	Con_CadUDieresis);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_UDieresisMinu,	Con_CadUDieresisMinu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_NTildeMayu,	Con_CadNTildeMayu);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_NTildeMinu,	Con_CadNTildeMinu);
    SET Par_Texto 			:= REPLACE(Par_Texto, Con_caracterInvi,	Cadena_Vacia);

	SET Var_Resultado := Par_Texto;

	RETURN Var_Resultado;

END$$
