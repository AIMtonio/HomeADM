-- SP REMESASWSCON

DELIMITER ;

DROP PROCEDURE IF EXISTS `REMESASWSCON`;

DELIMITER $$

CREATE PROCEDURE `REMESASWSCON` (
-- ================================================
-- ----- STORE PARA LA CONSULTA DE REMESAS --------
-- ================================================
    Par_RemesaWSID          BIGINT(20),         -- Numero de la Remesa
	Par_RemesaFolioID		VARCHAR(45),		-- Indica la referencia de pago.
    Par_ClabeCobroRemesa	VARCHAR(45),		-- Indica la clabe de cobro para la remesa',
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- Declaracion de Variables
    DECLARE Var_RemesaWSID          BIGINT(20);		-- Identificador de la remesa
    DECLARE Var_ClienteID           INT(11);		-- Almacena el Numero de Cliente de la Remesa
    DECLARE Var_UsuarioServicioID   INT(11);        -- Almacena el Numero del Usuario de Servicio
    DECLARE Var_Direccion           VARCHAR(500);   -- Almacena la Direccion del Cliente o Usuario

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
    DECLARE EsRegHacienda		CHAR(1);		-- Registro Hacienda: SI

    DECLARE EsFiscal			CHAR(1);		-- Direccion Fiscal: SI
    DECLARE EsOficial	    	CHAR(1);		-- Direccion Oficial: SI

    DECLARE Con_RefereRemesa	INT(11);		-- Consulta de Referencias de Remesas
    DECLARE Con_RefeClabeRemesa	INT(11);		-- Consulta de Referencias o clabe cobro de Remesas

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 			-- Entero Cero
    SET Decimal_Cero        	:= 0.00;		-- Decimal Cero
	SET Cadena_Vacia			:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
    SET EsRegHacienda			:= 'S';			-- Registro Hacienda: SI

    SET EsFiscal		    	:= 'S';			-- Direccion Fiscal: SI
    SET EsOficial	    		:= 'S';			-- Direccion Oficial: SI

	SET Con_RefereRemesa		:= 1;			-- Consulta de Referencias de Remesas (Pantalla Revision de Remesas)
	SET Con_RefeClabeRemesa		:= 3;

    -- 1.- Consulta de Referencias de Remesas (Pantalla Revision de Remesas)
	IF(Par_NumCon = Con_RefereRemesa)THEN
		-- SE OBTIENE INFORMACION DE LA REFERENCIA DE PAGO
        SELECT  RemesaWSID,         ClienteID,          UsuarioServicioID
        INTO    Var_RemesaWSID,     Var_ClienteID,      Var_UsuarioServicioID
		FROM REMESASWS
		WHERE RemesaFolioID = Par_RemesaFolioID;

		SET Var_RemesaWSID 	:= IFNULL(Var_RemesaWSID,Entero_Cero);
		SET Var_ClienteID 	:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Var_UsuarioServicioID 	:= IFNULL(Var_UsuarioServicioID,Entero_Cero);

        -- SI LA REMESA ES DE UN CLIENTE
		IF(Var_ClienteID > Entero_Cero)THEN
			SELECT Dir.DireccionCompleta
            INTO Var_Direccion
            FROM CLIENTES Cli
            INNER JOIN DIRECCLIENTE Dir
            ON Cli.ClienteID = Dir.ClienteID
            WHERE Cli.ClienteID = Var_ClienteID
            AND CASE WHEN Cli.RegistroHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END LIMIT 1;

			SET Var_Direccion 	:=IFNULL(Var_Direccion,Cadena_Vacia);

            IF(Var_Direccion = Cadena_Vacia)THEN
				SELECT Dir.DireccionCompleta
				INTO Var_Direccion
				FROM CLIENTES Cli
				INNER JOIN DIRECCLIENTE Dir
                ON Cli.ClienteID = Dir.ClienteID
				WHERE Cli.ClienteID = Var_ClienteID
                AND Dir.Oficial = EsOficial LIMIT 1;
            END IF;

			SET Var_Direccion 	:=IFNULL(Var_Direccion,Cadena_Vacia);

            IF(Var_Direccion = Cadena_Vacia)THEN
				SELECT DireccionCompleta
				INTO Var_Direccion
				FROM DIRECCLIENTE
				WHERE ClienteID = Var_ClienteID
                AND IFNULL(DireccionCompleta,Cadena_Vacia) != Cadena_Vacia LIMIT 1;
            END IF;

			SET Var_Direccion 	:=IFNULL(Var_Direccion,Cadena_Vacia);
        END IF;

		-- SI LA REMESA ES DE UN USUARIO DE SERVICIO
		IF(Var_UsuarioServicioID > Entero_Cero)THEN
            SELECT DirCompleta
            INTO Var_Direccion
            FROM USUARIOSERVICIO
            WHERE UsuarioServicioID = Var_UsuarioServicioID;

            SET Var_Direccion 	:=IFNULL(Var_Direccion,Cadena_Vacia);
        END IF;

        -- SE OBTIENE INFORMACION DE LA REMESA
		SELECT
			CONCAT(Rem.RemesaCatalogoID,'-',Cat.Nombre) AS Remesadora,
            Rem.ClienteID,
            Rem.UsuarioServicioID,
            Rem.Monto,
            Var_Direccion AS Direccion,
            Rem.MotivoRevision,
            Rem.FormaPago,
			CONCAT(Rem.TipoIdentiID,'-',Tip.Nombre) AS Identificacion,
            Rem.Estatus
		FROM REMESASWS Rem
        INNER JOIN REMESACATALOGO Cat
        ON Rem.RemesaCatalogoID = Cat.RemesaCatalogoID
		INNER JOIN TIPOSIDENTI Tip
        ON Rem.TipoIdentiID = Tip.TipoIdentiID
        WHERE Rem.RemesaWSID = Var_RemesaWSID;

    END IF;

    -- 3.- Consulta de Referencias O CLABE COBRO de Remesas (Pantalla ingreso operaciones)
	IF(Par_NumCon = Con_RefeClabeRemesa)THEN
		SELECT REM.RemesaFolioID, 	REM.ClabeCobroRemesa, 	REM.Monto, 				REM.RemesaCatalogoID, 	REM.ClienteID,
			REM.Direccion, 			REM.UsuarioServicioID,	REM.NumTelefonico, 		REM.TipoIdentiID, 		REM.FolioIdentific,
            REM.NombreCompletoRemit,CONCAT(REM.PaisIDRemitente,'-',PAI.Nombre) AS PaisIDRemitente,	CONCAT(REM.EstadoIDRemitente,'-',EST.Nombre) AS EstadoIDRemitente,
            CONCAT(REM.CiudadIDRemitente,'-',MUN.Nombre) AS CiudadIDRemitente,	CONCAT(REM.ColoniaIDRemitente,'-',COL.Asentamiento) AS ColoniaIDRemitente,
            REM.CodigoPostalRemitente, REM.DirecRemitente,	REM.Estatus,			REM.PermiteOperacion,	REM.FormaPago
        FROM REMESASWS REM
			LEFT JOIN PAISES PAI
				ON REM.PaisIDRemitente = PAI.PaisID
			LEFT JOIN ESTADOSREPUB EST
				ON REM.EstadoIDRemitente = EST.EstadoID
			LEFT JOIN MUNICIPIOSREPUB MUN
				ON REM.CiudadIDRemitente = MUN.MunicipioID
                AND REM.EstadoIDRemitente = MUN.EstadoID
			LEFT JOIN COLONIASREPUB COL
				ON REM.ColoniaIDRemitente = COL.ColoniaID
					AND REM.CiudadIDRemitente = COL.MunicipioID
                    AND REM.EstadoIDRemitente = COL.EstadoID
		WHERE REM.RemesaFolioID = Par_RemesaFolioID
			OR REM.ClabeCobroRemesa = Par_ClabeCobroRemesa;
    END IF;


END TerminaStore$$