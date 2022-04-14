-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HUELLADIGITALLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADIGITALLIS`;
DELIMITER $$

CREATE PROCEDURE `HUELLADIGITALLIS`(
	Par_CuentaAhoID		BIGINT,
    Par_Tipo			CHAR(1),			-- TIPO DE USUER/CLIET
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(20),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT	)
TerminaStore: BEGIN

	-- Declaración de variables.
	DECLARE Var_RFC					VARCHAR(13);
	DECLARE Var_RolID				CHAR(1);

	-- Declaración de constantes.
	DECLARE	Entero_Cero				INT;
	DECLARE	Lis_HuellaCuentas		INT;
    DECLARE Lis_HuellaUsuarios 		INT;
	DECLARE Lis_HuellaGeneral		INT;
	DECLARE Lis_HuellaVentanilla 	INT;

	DECLARE Lis_HuellaUsuarioServ	INT;			-- Lista huella usuario de servicios desde ventanilla.
    DECLARE HuellaMaestra   		VARCHAR(20);
    DECLARE EsFirmante	  			CHAR(1);
	DECLARE TipoFirmanteM   		CHAR(1);
	DECLARE Tipo_UsuarioServ		CHAR(1);		-- Constante tipo usuario: usuario de servicios 'S'.

	-- Asignación de constantes.
	SET	Entero_Cero				:= 0;
	SET	Lis_HuellaCuentas		:= 1;
    SET Lis_HuellaUsuarios		:= 2;
	SET Lis_HuellaGeneral		:= 3;
    SET Lis_HuellaVentanilla	:= 4;

	SET Lis_HuellaUsuarioServ	:= 5;
    SET EsFirmante				:= "S";
    SET TipoFirmanteM			:= 'U';
    SET HuellaMaestra   		:='HuellaMaestra';	-- Huella maestra
	SET Tipo_UsuarioServ		:= 'S';


	IF (Par_NumLis = Lis_HuellaCuentas) THEN
		SELECT Fir.NombreCompleto AS NombreFirmante,
			   CASE WHEN IFNULL(Per.ClienteID, 0) = 0 THEN 'F'
					ELSE 'C'
				END AS TipoFirmante,

				CASE WHEN IFNULL(Per.ClienteID, 0) = 0 THEN Fir.CuentaFirmaID
					ELSE Per.ClienteID
				END AS PersonaID,
				Hue.HuellaUno, Hue.DedoHuellaUno, Hue.HuellaDos, Hue.DedoHuellaDos

			FROM CUENTASFIRMA Fir
			INNER JOIN  CUENTASPERSONA Per ON (Fir.CuentaAhoID = Per.CuentaAhoID
										   AND Fir.PersonaID = Per.PersonaID )

			LEFT OUTER JOIN HUELLADIGITAL Hue ON CASE WHEN IFNULL(Per.ClienteID, 0) = 0 THEN 'F'
															ELSE 'C'
													END  = Hue.TipoPersona
													AND
												 CASE WHEN IFNULL(Per.ClienteID, 0) = 0 THEN Fir.CuentaFirmaID
													ELSE Per.ClienteID
												  END = Hue.PersonaID
			WHERE Fir.CuentaAhoID = Par_CuentaAhoID;

	END IF;

    IF Par_NumLis = Lis_HuellaUsuarios THEN

        SELECT RFCOficial
        INTO Var_RFC
        FROM CLIENTES WHERE ClienteID = Par_CuentaAhoID;


		SELECT hue.TipoPersona,hue.PersonaID FROM HUELLADIGITAL hue, USUARIOS usu
		WHERE
        hue.TipoPersona = 'U'
        AND hue.PersonaID = usu.UsuarioID
	    AND usu.RFC != Var_RFC;

    END IF;

    IF (Par_NumLis = Lis_HuellaGeneral) THEN

		IF(Par_Tipo = 'C')THEN
			SELECT RFCOficial INTO Var_RFC
				FROM CLIENTES
                WHERE ClienteID = Par_CuentaAhoID;

             SELECT hue.TipoPersona,hue.PersonaID
			  FROM HUELLADIGITAL hue
			  INNER JOIN CLIENTES Cli on hue.PersonaID = Cli.ClienteID
				WHERE Cli.RFCOficial != Var_RFC  AND Cli.RFCOficial !=''
				AND hue.TipoPersona = 'C'
			UNION
				SELECT hue.TipoPersona,hue.PersonaID
				  FROM HUELLADIGITAL hue
				  INNER JOIN USUARIOS U on hue.PersonaID = U.UsuarioID
				WHERE U.RFC != Var_RFC -- AND U.RFC !=''
                AND hue.TipoPersona = 'U'
			UNION
				SELECT hue.TipoPersona, hue.PersonaID
                FROM HUELLADIGITAL hue
                INNER JOIN CUENTASPERSONA Per on hue.PersonaID = CONCAT(Per.CuentaAhoID,CASE WHEN LENGTH(Per.PersonaID)>1
																			THEN Per.PersonaID ELSE CONCAT(0,Per.PersonaID) END)
				where Per.RFC != Var_RFC AND Per.RFC != ''
                AND hue.TipoPersona = 'F';
        END IF;


        IF(Par_Tipo = 'U')THEN
			SELECT RFC INTO Var_RFC
				FROM USUARIOS
                WHERE UsuarioID = Par_CuentaAhoID;

           SELECT hue.TipoPersona,hue.PersonaID
			  FROM HUELLADIGITAL hue
			  INNER JOIN CLIENTES Cli on hue.PersonaID = Cli.ClienteID
				WHERE Cli.RFCOficial != Var_RFC  AND Cli.RFCOficial !=''
				AND hue.TipoPersona = 'C'
			UNION
				SELECT hue.TipoPersona,hue.PersonaID
				  FROM HUELLADIGITAL hue
				  INNER JOIN USUARIOS U on hue.PersonaID = U.UsuarioID
				WHERE U.RFC != Var_RFC AND U.RFC !=''
                AND hue.TipoPersona = 'U'
			UNION
				SELECT hue.TipoPersona, hue.PersonaID
                FROM HUELLADIGITAL hue
                INNER JOIN CUENTASPERSONA Per on hue.PersonaID = CONCAT(Per.CuentaAhoID,CASE WHEN LENGTH(Per.PersonaID)>1
																			THEN Per.PersonaID ELSE CONCAT(0,Per.PersonaID) END)
				where Per.RFC != Var_RFC AND Per.RFC != ''
                AND hue.TipoPersona = 'F';
        END IF;

        IF(Par_Tipo = 'F')THEN
			SELECT RFC INTO Var_RFC
				FROM CUENTASPERSONA
                WHERE CONCAT(CuentaAhoID,CASE WHEN LENGTH(PersonaID)>1
					  THEN PersonaID ELSE CONCAT(0,PersonaID) END) = Par_CuentaAhoID;

             SELECT hue.TipoPersona,hue.PersonaID
			  FROM HUELLADIGITAL hue
			  INNER JOIN CLIENTES Cli on hue.PersonaID = Cli.ClienteID
				WHERE Cli.RFCOficial != Var_RFC AND Cli.RFCOficial !=''
				AND hue.TipoPersona = 'C'
			UNION
				SELECT hue.TipoPersona,hue.PersonaID
				  FROM HUELLADIGITAL hue
				  INNER JOIN USUARIOS U on hue.PersonaID = U.UsuarioID
				WHERE U.RFC != Var_RFC AND U.RFC !=''
                AND hue.TipoPersona = 'U'
			UNION
				SELECT hue.TipoPersona, hue.PersonaID
                FROM HUELLADIGITAL hue
                INNER JOIN CUENTASPERSONA Per on hue.PersonaID = CONCAT(Per.CuentaAhoID,CASE WHEN LENGTH(Per.PersonaID)>1
																			THEN Per.PersonaID ELSE CONCAT(0,Per.PersonaID) END)
				where Per.RFC != Var_RFC AND Per.RFC != ''
                AND hue.TipoPersona = 'F';
        END IF;

    END IF;

    IF(Par_NumLis = Lis_HuellaVentanilla)  THEN
	 SET Var_RolID :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro=HuellaMaestra);

     DROP TABLE IF EXISTS   HUELLAMAESTRA;
		 CREATE TEMPORARY TABLE HUELLAMAESTRA (
            NombreFirmante	        VARCHAR(200),
            TipoFirmante	        CHAR(1),
            PersonaID	            INT(12),
            HuellaUno	            VARBINARY(4000),
            DedoHuellaUno	        CHAR(1),
            HuellaDos	            VARBINARY(4000),
            DedoHuellaDos	        CHAR(1)
		 );

		INSERT INTO HUELLAMAESTRA
			 SELECT C.NombreCompleto, H.TipoPersona,	H.PersonaID,	H.HuellaUno,	H.DedoHuellaUno,	H.HuellaDos,
			 H.DedoHuellaDos
			FROM HUELLADIGITAL H
            INNER JOIN CLIENTES C ON H.PersonaID = C.ClienteID
				WHERE
					H.TipoPersona='C'
					AND H.PersonaID= Par_CuentaAhoID;

		INSERT INTO HUELLAMAESTRA
        SELECT Usu.NombreCompleto,Hue.TipoPersona, Hue.PersonaID, Hue.HuellaUno, Hue.DedoHuellaUno, Hue.HuellaDos, Hue.DedoHuellaDos
				FROM USUARIOS Usu
				INNER JOIN HUELLADIGITAL Hue
					ON Usu.UsuarioID = Hue.PersonaID
				WHERE Usu.RolID=Var_RolID
                AND Usu.AccedeHuella=EsFirmante
                AND Usu.SucursalUsuario=Aud_Sucursal
                AND Hue.TipoPersona=TipoFirmanteM;

        SELECT NombreFirmante, TipoFirmante, PersonaID, HuellaUno, DedoHuellaUno, HuellaDos, DedoHuellaDos FROM HUELLAMAESTRA;

	END IF;

	-- Lista huella usuario de servicios desde ventanilla.
	IF (Par_NumLis = Lis_HuellaUsuarioServ) THEN

		SET Var_RolID := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = HuellaMaestra);

		DROP TABLE IF EXISTS HUELLAMAESTRA;
		CREATE TEMPORARY TABLE HUELLAMAESTRA (
			NombreFirmante	        VARCHAR(200),
			TipoFirmante	        CHAR(1),
			PersonaID	            INT(12),
			HuellaUno	            VARBINARY(4000),
			DedoHuellaUno	        CHAR(1),
			HuellaDos	            VARBINARY(4000),
			DedoHuellaDos	        CHAR(1)
		);

		INSERT INTO HUELLAMAESTRA (
			NombreFirmante,		TipoFirmante,	PersonaID,		HuellaUno,		DedoHuellaUno,
			HuellaDos,			DedoHuellaDos
		) SELECT
			USS.NombreCompleto,	HD.TipoPersona,	HD.PersonaID,	HD.HuellaUno,	HD.DedoHuellaUno,
			HD.HuellaDos,		HD.DedoHuellaDos
		FROM HUELLADIGITAL HD
        INNER JOIN USUARIOSERVICIO USS ON USS.UsuarioServicioID = HD.PersonaID
		WHERE HD.PersonaID = Par_CuentaAhoID
		AND HD.TipoPersona = Tipo_UsuarioServ;

		INSERT INTO HUELLAMAESTRA (
			NombreFirmante,		TipoFirmante,	PersonaID,		HuellaUno,		DedoHuellaUno,
			HuellaDos,			DedoHuellaDos
        ) SELECT
			US.NombreCompleto,	HD.TipoPersona,	HD.PersonaID,	HD.HuellaUno,	HD.DedoHuellaUno,
			HD.HuellaDos,		HD.DedoHuellaDos
		FROM USUARIOS US
		INNER JOIN HUELLADIGITAL HD ON US.UsuarioID = HD.PersonaID
		WHERE US.RolID = Var_RolID
        AND US.AccedeHuella = EsFirmante
        AND US.SucursalUsuario = Aud_Sucursal
        AND HD.TipoPersona = TipoFirmanteM;

        SELECT	NombreFirmante,	TipoFirmante,	PersonaID,	HuellaUno,	DedoHuellaUno,
				HuellaDos,		DedoHuellaDos
		FROM HUELLAMAESTRA;

	END IF;

END TerminaStore$$