-- APPWUSUARIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWUSUARIOSCON`;
DELIMITER $$


CREATE PROCEDURE `APPWUSUARIOSCON`(

    Par_UsuarioID           BIGINT(12),
    Par_NumCon              TINYINT UNSIGNED,
    Par_ClienteID           BIGINT(12),
    Par_TelefonoCelular     VARCHAR(20),
    Par_TarjetaID           VARCHAR(16),				-- numero de tarjeta debito o credito

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de varianbles
	DECLARE Var_ClienteID		INT(11);			-- Variable para el numero del cliente
	DECLARE Var_TotalDeb		INT(11);			-- Variable para el numero total las tarjetas de debito
	DECLARE Var_TotalCred		INT(11);			-- Variable para el numero total de las tarjetas credito

	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Con_Principal   INT;
	DECLARE Con_Tarjeta		INT(11);
	DECLARE Con_ClienteID	INT;

	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Con_Principal       := 1;
	SET Con_Tarjeta			:= 2;
	SET Con_ClienteID		:= 3;

	IF(Par_NumCon = Con_Principal) THEN

		SELECT ClienteID INTO Var_ClienteID FROM APPWUSUARIOS WHERE TelefonoCelular = Par_TelefonoCelular;

		SELECT COUNT(*) INTO Var_TotalDeb FROM TARJETADEBITO WHERE ClienteID = Var_ClienteID;
		SELECT COUNT(*) INTO Var_TotalCred FROM TARJETACREDITO WHERE ClienteID = Var_ClienteID;

		SELECT  UsuarioID,           ClienteID,        Contrasenia,       PrimerNombre,     SegundoNombre,
				TercerNombre,        ApellidoPaterno,  ApellidoMaterno,   NombreCompleto,      Curp,
				Estatus,             FechaCreacion,    Correo,            TelefonoCelular,  PrefijoTelefonico,   Tiene_NIP,
				ImagenAntiphishingNumber,  FechaNacimiento,  DispositivoID,     FechaUltAcceso,   LoginsFallidos,
				EstatusSesion,       FechaCancel,      MotivoCancel,      FechaBloqueo,     MotivoBloqueo,
				EmpresaID,           Usuario,          FechaActual,       DireccionIP,      ProgramaID,
				Sucursal,            NumTransaccion,	(Var_TotalDeb+Var_TotalCred) AS TotalCard
			FROM APPWUSUARIOS
				WHERE
					IF(Par_UsuarioID                !=Entero_Cero, (UsuarioID = Par_UsuarioID), true)
					AND IF(Par_ClienteID            !=Entero_Cero, (ClienteID = Par_ClienteID), true)
					AND IF(Par_TelefonoCelular      !=Cadena_Vacia, (TelefonoCelular = Par_TelefonoCelular), true);
	END IF;

	IF(Par_NumCon = Con_Tarjeta) THEN

		SELECT ClienteID INTO Var_ClienteID FROM TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaID;

		SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

		IF Var_ClienteID = Entero_Cero THEN
			SELECT ClienteID INTO Var_ClienteID FROM TARJETACREDITO WHERE TarjetaCredID = Par_TarjetaID;
		END IF;

		SELECT 	CLI.ClienteID, 								CLI.CURP, 				CLI.PrimerNombre, 					CLI.SegundoNombre, 		CLI.TercerNombre,
				CLI.ApellidoPaterno, 						CLI.ApellidoMaterno, 	CLI.TelefonoCelular, 				CLI.Correo, 			CLI.FechaNacimiento,
				IF(TARU.UsuarioID IS NULL, "0",'1') AS Enrolled,	TARU.Contrasenia,		IMG.ImagenBinaria,		TARU.DispositivoID
			FROM CLIENTES CLI
			LEFT JOIN APPWUSUARIOS TARU ON CLI.ClienteID = TARU.ClienteID
			LEFT JOIN APPWIMGANTIPHISHING IMG ON TARU.ImagenAntiphishingNumber = IMG.ImagenPhishingID
			WHERE CLI.ClienteID = Var_ClienteID;

	END IF;

	IF(Par_NumCon = Con_ClienteID) THEN

		SELECT  UsuarioID,           ClienteID,        Contrasenia,       PrimerNombre,     SegundoNombre,
				TercerNombre,        ApellidoPaterno,  ApellidoMaterno,   NombreCompleto,      Curp,
				Estatus,             FechaCreacion,    Correo,            TelefonoCelular,  PrefijoTelefonico,   Tiene_NIP,
				ImagenAntiphishingNumber,  FechaNacimiento,  DispositivoID,     FechaUltAcceso,   LoginsFallidos,
				EstatusSesion,       FechaCancel,      MotivoCancel,      FechaBloqueo,     MotivoBloqueo,
				EmpresaID,           Usuario,          FechaActual,       DireccionIP,      ProgramaID,
				Sucursal,            NumTransaccion,	(Var_TotalDeb+Var_TotalCred) AS TotalCard
			FROM APPWUSUARIOS
				WHERE
					IF(Par_ClienteID            !=Entero_Cero, (ClienteID = Par_ClienteID), true);

	END IF;


END TerminaStore$$
