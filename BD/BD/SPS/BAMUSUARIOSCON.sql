-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMUSUARIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMUSUARIOSCON`;DELIMITER $$

CREATE PROCEDURE `BAMUSUARIOSCON`(
	-- SP Para consultar un usuario de la banca movil

	Par_ClienteID			INT(11),			-- Cliente usuario de la banca movil a consultar
    Par_Email				VARCHAR(50),		-- Consultar por email
	Par_Telefono			VARCHAR(50),		-- Consultar por numero celular
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID       	INT(11),  			-- Auditoria

    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria

    Aud_NumTransaccion  	BIGINT(20) 			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal	INT; 				-- Consulta pricipal
    DECLARE Con_Email		INT; 				-- Realiza la consulta en base al email
	DECLARE Con_Telefono	INT; 				-- Realiza la consulta en base al telefono
	DECLARE Con_NIP			INT; 				-- Realiza la consulta del nip del usuario
    DECLARE Var_FolioTokenMON	VARCHAR(50);		-- Realiza la consulta en bASe al telefono
    DECLARE Var_FolioTokenMOF	VARCHAR(50);		-- Realiza la consulta en bASe al telefono
    DECLARE Var_ClienteID   BIGINT(20);			-- Cliente ID
	DECLARE Cadena_Vacia	VARCHAR(2);
    DECLARE Tipo_MON		VARCHAR(3);
    DECLARE Tipo_MOF		VARCHAR(3);
    DECLARE Est_Activo		CHAR(1);

	/* ASignacion de Constantes */
	SET	Con_Principal		:= 1;	-- Consulta Principal
    SET	Con_Telefono		:= 2;	-- Consulta de Telefono
    SET	Con_Email			:= 3;	-- Consulta de Email
    SET Con_NIP				:= 4;	-- Consulta de NIP
    SET Cadena_Vacia		:= '';
    SET Tipo_MON			:= 'MON';
    SET Tipo_MOF			:= 'MOF';
    SET Est_Activo			:= 'A';


	IF (Par_NumCon=Con_Principal) THEN


		SELECT FolioSerie INTO Var_FolioTokenMON FROM BAMTOKENS WHERE ClienteID=Par_ClienteID AND Estatus=Est_Activo AND TipoToken = Tipo_MON;
		SELECT FolioSerie INTO Var_FolioTokenMOF FROM BAMTOKENS WHERE ClienteID=Par_ClienteID AND Estatus=Est_Activo AND TipoToken = Tipo_MOF;

        SET Var_FolioTokenMON := IFNULL(Var_FolioTokenMON,Cadena_Vacia);
        SET Var_FolioTokenMOF := IFNULL(Var_FolioTokenMOF,Cadena_Vacia);


		SELECT 	UsuarioID,									ClienteID,			NIP,							Telefono,						Email,
				CONCAT(FNFECHATEXTO(FechaUltimoAcceso), 	" ",				DATE_FORMAT(FechaUltimoAcceso, '%T')) AS FechaUltimoAcceso,		Estatus,
				FechaCancelacion,							FechaBloqueo,		MotivoBloqueo,					MotivoCancelacion,				FechaCreacion,
				RespuestaPregSecreta,						PerfilID,			PreguntASecretaID,				Var_FolioTokenMON AS TokenMON,	Var_FolioTokenMOF AS TokenMOF,
				ImagenLoginID,  							FraseBienvenida,	ImagenAntPhisPerson
		FROM BAMUSUARIOS
		WHERE ClienteID	= Par_ClienteID LIMIT 1;


	END IF;


	IF (Par_NumCon=Con_Email) THEN
			SELECT 	UsuarioID,			ClienteID,				NIP,				Telefono,			CONCAT(FNFECHATEXTO(FechaUltimoAcceso), " ", DATE_FORMAT(FechaUltimoAcceso, '%T')) AS FechaUltimoAcceso,
					Estatus,			FechaCancelacion,		FechaBloqueo,		MotivoBloqueo,		MotivoCancelacion,
					FechaCreacion,		RespuestaPregSecreta,	PerfilID,			Email,				PreguntaSecretaID,
					TokenID,			ImagenLoginID,			FraseBienvenida,	ImagenAntPhisPerson
			FROM BAMUSUARIOS
			WHERE Email	= Par_Email LIMIT 1;

	END IF;

	IF (Par_NumCon=Con_Telefono) THEN
			SET Var_ClienteID = (SELECT ClienteID FROM BAMUSUARIOS WHERE Telefono = Par_Telefono);
            SELECT FolioSerie INTO Var_FolioTokenMON FROM BAMTOKENS WHERE ClienteID=Var_ClienteID AND Estatus=Est_Activo AND TipoToken = Tipo_MON;
			SELECT FolioSerie INTO Var_FolioTokenMOF FROM BAMTOKENS WHERE ClienteID=Var_ClienteID AND Estatus=Est_Activo AND TipoToken = Tipo_MOF;

			SET Var_FolioTokenMON := IFNULL(Var_FolioTokenMON,Cadena_Vacia);
			SET Var_FolioTokenMOF := IFNULL(Var_FolioTokenMOF,Cadena_Vacia);


			SELECT 	UsuarioID,			ClienteID,				NIP,			Telefono,			 CONCAT(FNFECHATEXTO(FechaUltimoAcceso), " ", DATE_FORMAT(FechaUltimoAcceso, '%T')) AS FechaUltimoAcceso,
					Estatus,			FechaCancelacion,		FechaBloqueo,	MotivoBloqueo,		 MotivoCancelacion,
					FechaCreacion,		RespuestaPregSecreta,	PerfilID,		Email,				 PreguntASecretaID,
					TokenID,			ImagenLoginID,			FraseBienvenida,ImagenAntPhisPerson, Var_FolioTokenMON AS TokenMON,
                    Var_FolioTokenMOF AS TokenMOF
			FROM BAMUSUARIOS
			WHERE Telefono	= Par_Telefono LIMIT 1;


	END IF;

	IF (Par_NumCon=Con_NIP) THEN
		SELECT NIP
		FROM BAMUSUARIOS
		WHERE Telefono	= Par_Telefono LIMIT 1;

	END IF;
END TerminaStore$$