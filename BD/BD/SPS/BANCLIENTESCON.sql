-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCLIENTESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCLIENTESCON`;
DELIMITER $$

CREATE PROCEDURE `BANCLIENTESCON`(

	Par_Curp				VARCHAR(20),
	Par_NumCon		    	TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);

	DECLARE Con_Curp				INT(11);
	DECLARE Con_Principal			INT(11);
	DECLARE	Fisica_Empresa			CHAR(1);
	DECLARE Fisica_NoEmpresa		CHAR(1);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Con_Curp			:= 1;
	SET Con_Principal		:= 2;

	SET Par_Curp			:= IFNULL(Par_Curp,Cadena_Vacia);
	SET Par_NumCon			:= IFNULL(Par_NumCon,Entero_Cero);
	SET	Fisica_Empresa		:= 'A';
	SET Fisica_NoEmpresa	:= 'F';


	IF(Par_NumCon = Con_Curp)THEN

		IF(Par_Curp = Cadena_Vacia ) THEN
			SELECT CURP,	ClienteID
			FROM CLIENTES LIMIT 0;
		ELSE
			SELECT CURP,	ClienteID
			FROM CLIENTES
			WHERE	CURP = Par_Curp;
		END IF;

	END IF;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT  ClienteID,			CURP,				TipoPersona,		PrimerNombre,			SegundoNombre,
				TercerNombre,		ApellidoPaterno, 	ApellidoMaterno, 	NombreCompleto,			FechaNacimiento,
				Sexo,				TelefonoCelular,	EstadoID,			Nacion
			FROM CLIENTES
			WHERE CURP = Par_CURP
			AND (TipoPersona = Fisica_Empresa OR TipoPersona=Fisica_NoEmpresa);
	END IF;

END TerminaStore$$
