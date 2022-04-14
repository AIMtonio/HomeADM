-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALUARIESGOCOMUNPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALUARIESGOCOMUNPRO`;
DELIMITER $$


CREATE PROCEDURE `EVALUARIESGOCOMUNPRO`(
# =====================================================================================
# ----- STORED PARA EVALUAR CLIENTES QUE REPRESENTEN UN  RIESGO COMUN -----------------
# ----- EN EL ALTA DE SOLICITUD DE CREDITO INDIIDUAL O GRUPAL  				  ---------
# =====================================================================================
    Par_SolicitudCreditoID	BIGINT(20),		-- ID de la solicitud de credito
    Par_ClienteID			INT(11),		-- ID del cliente solicitante
	Par_ProspectoID     	BIGINT(20),

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE Var_PrimerNombre		VARCHAR(50);
    DECLARE Var_SegundoNombre		VARCHAR(50);
    DECLARE Var_TercerNombre		VARCHAR(50);

    DECLARE Var_ApellidoPaterno		VARCHAR(50);
	DECLARE Var_ApellidoMaterno		VARCHAR(50);
    DECLARE Var_FechaNacimiento		DATE;
    DECLARE Var_GrupoEmpresarial	INT(11);
	DECLARE Var_RFCOficial			CHAR(13);

    DECLARE Var_TelefonoCelular 	VARCHAR(20);
    DECLARE Var_Telefono			VARCHAR(20);
    DECLARE Var_TipoPersona			CHAR(1);

    DECLARE Var_EstadoID			INT(11);
    DECLARE Var_MunicipioID			INT(11);
	DECLARE Var_LocalidadID			INT(11);
    DECLARE Var_ColoniaID			INT(11);
    DECLARE Var_Calle				CHAR(50);

    DECLARE Var_NumeroCasa			CHAR(10);
    DECLARE Var_ClienteIDConyu		INT(11);
    DECLARE Var_NumDirectivos		INT(11);
    DECLARE Var_AuxInt				INT(11);
    DECLARE Var_PrimerNombreDir		VARCHAR(50);

    DECLARE Var_SegundoNombreDir	VARCHAR(50);
    DECLARE Var_TercerNombreDir		VARCHAR(50);

    DECLARE Var_ApellidoPaternoDir	VARCHAR(50);
	DECLARE Var_ApellidoMaternoDir	VARCHAR(50);
    DECLARE Var_DirectivoID			INT(11);
    DECLARE Var_FechaNacimientoDir 	DATE;
    DECLARE Var_RFCDir				CHAR(13);

    DECLARE Var_NumResult			INT(11);
    DECLARE Var_RelacionadoID		INT(11);

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE TipoPersonaMoral	CHAR(1);			-- Tipo de persona moral
    DECLARE Credito_Vigente		CHAR(1);			-- Credito estatus vigente
    DECLARE Credito_Vencido		CHAR(1);			-- Credito estatus vencido

    DECLARE Credito_Castigado	CHAR(1);			-- Credito estatus castigado
    DECLARE Cons_Si 			CHAR(1);
    DECLARE Est_Pend			CHAR(1);


    -- RIESGOS
	DECLARE Var_NumRiesgosComun   INT(11);
	DECLARE Var_BusqRiesgoComun   CHAR(1);          -- Valida si realiza la Busqueda de Riesgos
	DECLARE ValidaBusqRiesComun   VARCHAR(25);
	DECLARE DescPersRelacionada   VARCHAR(25);

    DECLARE Var_SolicitudCre      INT;              -- Solicitud de credito ID
	DECLARE Var_NumRiesgoPersRel  INT(11);		    -- Indica la cantidad de registros con riesgo en persona relacionada

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET TipoPersonaMoral		:= 'M';
    SET Credito_Vigente			:= 'V';
    SET Credito_Vencido			:= 'B';

    SET Credito_Castigado		:= 'K';
    SET Cons_Si					:= 'S';
	SET Est_Pend				:= 'P';

    SET ValidaBusqRiesComun   := 'ValidaBusqRiesComun'; -- Valida la Busqueda de Riesgo Comun
    SET DescPersRelacionada   := 'PERSONA RELACIONADA'; -- Descripcion Persona Relacionada


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: SP-EVALUARIESGOCOMUNPRO');
                SET Var_Control = 'SQLEXCEPTION';
            END;

		SET @Num:=0;

		-- RESPALDO DE LOS REGISTROS EN TMP_RIESGOCOMUNCLICRE
		DELETE FROM TMP_RIESGOCOMUNCLICRE
        WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		INSERT INTO TMP_RIESGOCOMUNCLICRE
		SELECT
				SolicitudCreditoID,			ConsecutivoID,		 ClienteIDSolicitud,			ProspectoID,		CreditoID,
			    ClienteID,					NombreCompleto,		 ParentescoID,					Estatus,			Clave,
				Motivo,						Comentario,			 RiesgoComun,					Procesado,			EmpresaID,
				Usuario,					FechaActual,		 DireccionIP,					ProgramaID,			Sucursal,
				NumTransaccion
		FROM RIESGOCOMUNCLICRE
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

        -- ELIMINA LOS REGISTROS
        DELETE FROM RIESGOCOMUNCLICRE
        WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET @Num:= (SELECT  COUNT(ConsecutivoID)  FROM  TMP_RIESGOCOMUNCLICRE WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

        -- DATOS SI ES CLIENTE
        IF(Par_ClienteID > Entero_Cero)THEN
			 -- CONSULTAMOS LOS DATOS DEL CLIENTE QUE REALIZA LA SOLICITUD DE CREDITO
			SELECT 	CLI.PrimerNombre, 		CLI.SegundoNombre, 		CLI.TercerNombre, 	CLI.ApellidoPaterno,	CLI.ApellidoMaterno,
					CLI.FechaNacimiento, 	CLI.GrupoEmpresarial,	CLI.RFCOficial, 	CLI.TelefonoCelular, 	CLI.Telefono,
					CLI.TipoPersona,		DIR.EstadoID,			DIR.MunicipioID,
					DIR.LocalidadID,		DIR.ColoniaID,			DIR.Calle,			DIR.NumeroCasa
			INTO 	Var_PrimerNombre, 		Var_SegundoNombre, 		Var_TercerNombre, 	Var_ApellidoPaterno,	Var_ApellidoMaterno,
					Var_FechaNacimiento, 	Var_GrupoEmpresarial,	Var_RFCOficial, 	Var_TelefonoCelular, 	Var_Telefono,
					Var_TipoPersona,		Var_EstadoID,			Var_MunicipioID,
					Var_LocalidadID,		Var_ColoniaID,			Var_Calle,			Var_NumeroCasa
			FROM CLIENTES CLI
				LEFT JOIN DIRECCLIENTE DIR
					ON CLI.ClienteID = DIR.ClienteID AND DIR.Oficial = 'S'
			WHERE CLI.ClienteID = Par_ClienteID;

        ELSE

            -- DATOS SI ES PROSPECTO
			-- CONSULTAMOS LOS DATOS DEL PROSPECTOPROSPECTOSPROSPECTOS QUE REALIZA LA SOLICITUD DE CREDITO
			SELECT 	PRO.PrimerNombre, 		PRO.SegundoNombre, 		PRO.TercerNombre, 	PRO.ApellidoPaterno,	PRO.ApellidoMaterno,
					PRO.FechaNacimiento, 	Entero_Cero,			PRO.RFC, 			PRO.Telefono,		 	Cadena_Vacia,
					PRO.TipoPersona,		PRO.EstadoID,			PRO.MunicipioID,
					PRO.LocalidadID,		PRO.ColoniaID,			PRO.Calle,			PRO.NumExterior
			INTO 	Var_PrimerNombre, 		Var_SegundoNombre, 		Var_TercerNombre, 	Var_ApellidoPaterno,	Var_ApellidoMaterno,
					Var_FechaNacimiento, 	Var_GrupoEmpresarial,	Var_RFCOficial, 	Var_TelefonoCelular, 	Var_Telefono,
					Var_TipoPersona,		Var_EstadoID,			Var_MunicipioID,
					Var_LocalidadID,		Var_ColoniaID,			Var_Calle,			Var_NumeroCasa
			FROM PROSPECTOS PRO
			WHERE PRO.ProspectoID = Par_ProspectoID;


        END IF;


        -- SETEA VALORES PARA ELIMINAR VALORES NULOS
        SET Var_PrimerNombre := IFNULL(Var_PrimerNombre,Cadena_Vacia);
        SET Var_SegundoNombre := IFNULL(Var_SegundoNombre,Cadena_Vacia);
        SET Var_TercerNombre := IFNULL(Var_TercerNombre,Cadena_Vacia);
        SET Var_ApellidoPaterno := IFNULL(Var_ApellidoPaterno,Cadena_Vacia);
        SET Var_ApellidoMaterno := IFNULL(Var_ApellidoMaterno,Cadena_Vacia);

        SET Var_FechaNacimiento := IFNULL(Var_FechaNacimiento,Fecha_Vacia);
        SET Var_GrupoEmpresarial := IFNULL(Var_GrupoEmpresarial, Entero_Cero);
        SET Var_RFCOficial := IFNULL(Var_RFCOficial,Cadena_Vacia);
        SET Var_TelefonoCelular := IFNULL(Var_TelefonoCelular,Cadena_Vacia);
        SET Var_Telefono := IFNULL(Var_Telefono,Cadena_Vacia);

        SET Var_TipoPersona := IFNULL(Var_TipoPersona,Cadena_Vacia);
        SET Var_EstadoID := IFNULL(Var_EstadoID,Entero_Cero);
        SET Var_MunicipioID := IFNULL(Var_MunicipioID,Entero_Cero);

        SET Var_LocalidadID := IFNULL(Var_LocalidadID,Entero_Cero);
        SET Var_ColoniaID := IFNULL(Var_ColoniaID,Entero_Cero);
        SET Var_Calle := IFNULL(Var_Calle,Cadena_Vacia);
        SET Var_NumeroCasa := IFNULL(Var_NumeroCasa,Cadena_Vacia);


        -- VALIDACIONES CUANDO EL CLIENTE SOLICITANTE ES PERSONA FISICA O FISICA CON ACTVIDAD EMPRESARIAL
        IF(Var_TipoPersona <> TipoPersonaMoral)THEN


            -- 1 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS CON MISMOS APELLIDOS
 			INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,			Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 	Entero_Cero,		Est_Pend,        	Entero_Cero,
                    "MISMOS APELLIDOS",			Cadena_Vacia,			'S',				'N',                Par_EmpresaID,
                    Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                    Aud_NumTransaccion
			FROM CREDITOS CRE
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona <> TipoPersonaMoral
				AND CLI.ApellidoPaterno = Var_ApellidoPaterno
				AND CLI.ApellidoMaterno = Var_ApellidoMaterno
                AND CRE.ClienteID <> Par_ClienteID;

            -- 2 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS CON MISMO CELULAR O TELEFONO
			INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,			Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		   	Est_Pend,        	Entero_Cero,
                    CASE
						WHEN CLI.TelefonoCelular = Var_TelefonoCelular THEN "MISMOS CELULARES"
					ELSE "MISMOS TELEFONOS" END,Cadena_Vacia,				'S',					'N',                Par_EmpresaID,
                    Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
                    Aud_NumTransaccion
			FROM CREDITOS CRE
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona <> TipoPersonaMoral
                AND CLI.ClienteID <> Par_ClienteID
				AND ((CLI.TelefonoCelular = Var_TelefonoCelular AND CLI.TelefonoCelular <> Cadena_Vacia) OR
					(CLI.Telefono = Var_Telefono AND CLI.Telefono <> Cadena_Vacia));

            -- 3 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS DONDE EL CONYUGUE TENGA EL MISMO RFC QUE EL USUARIO SOLICITANTE
            INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID,				CLI.NombreCompleto, 		Entero_Cero,		Est_Pend,          	Entero_Cero,
					"CONYUGUE RFC",				Cadena_Vacia,				'S',               'N',                 Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion
            FROM SOCIODEMOCONYUG CON
				INNER JOIN CREDITOS CRE
					ON CON.ClienteID = CRE.ClienteID
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona <> TipoPersonaMoral
				AND CON.RFC = Var_RFCOficial
                AND CON.RFC <> Cadena_Vacia;

            -- 4 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS DONDE EL CONYUGUE TENGA EL MISMO NOMBRE
			INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		Est_Pend,        	Entero_Cero,
					"CONYUGUE NOMBRE",			Cadena_Vacia,				'S',               'N',                 Par_EmpresaID,
                    Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                    Aud_NumTransaccion
			FROM SOCIODEMOCONYUG CON
				INNER JOIN CREDITOS CRE
					ON CON.ClienteID = CRE.ClienteID
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona <> TipoPersonaMoral
				AND CON.PrimerNombre = Var_PrimerNombre
				AND CON.SegundoNombre = Var_SegundoNombre
				AND CON.TercerNombre = Var_TercerNombre
				AND CON.ApellidoPaterno = Var_ApellidoPaterno
				AND CON.ApellidoMaterno = Var_ApellidoMaterno;

            -- 5 CLIENTES PERSONAS MORALES CON CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS DONDE LOS DIRECTIVOS
            -- TENGAN EL MISMO NOMBRE Y APELLIDOS
			INSERT INTO TMP_RIESGOCOMUNCLICRE
			SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		Est_Pend,        	Entero_Cero,
                    CASE WHEN DIR.EsAccionista = Cons_Si THEN CONCAT("DIRECTIVOS NOMBRE",' ', PorcentajeAcciones,'%')
                    ELSE "DIRECTIVOS NOMBRE" END,Cadena_Vacia,				'S',               'N',                  Par_EmpresaID,
                    Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                    Aud_NumTransaccion
			FROM DIRECTIVOS DIR
				INNER JOIN CREDITOS CRE
					ON DIR.ClienteID = CRE.ClienteID AND CRE.ClienteID <> Par_ClienteID
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
				LEFT JOIN CLIENTES CTE
					ON DIR.RelacionadoID = CTE.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona = TipoPersonaMoral
				AND ((DIR.PrimerNombre = Var_PrimerNombre
					AND DIR.SegundoNombre = Var_SegundoNombre
					AND DIR.TercerNombre = Var_TercerNombre
					AND DIR.ApellidoPaterno = Var_ApellidoPaterno
					AND DIR.ApellidoMaterno = Var_ApellidoMaterno)
				OR
                    (CTE.PrimerNombre = Var_PrimerNombre
					AND CTE.SegundoNombre = Var_SegundoNombre
					AND CTE.TercerNombre = Var_TercerNombre
					AND CTE.ApellidoPaterno = Var_ApellidoPaterno
					AND CTE.ApellidoMaterno = Var_ApellidoMaterno));


            -- 6 CLIENTES PERSONAS MORALES CON CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS DONDE LOS DIRECTIVOS NO SON CLIENTES
            -- Y TENGAN EL MISMO RFC
            INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		Est_Pend,        	Entero_Cero,
                    CASE WHEN DIR.EsAccionista = Cons_Si THEN CONCAT( "DIRECTIVOS RFC",' ', PorcentajeAcciones,'%')
                    ELSE "DIRECTIVOS RFC" END,	Cadena_Vacia,				'S',                'N',                Par_EmpresaID,
                    Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                    Aud_NumTransaccion
			FROM DIRECTIVOS DIR
				INNER JOIN CREDITOS CRE
					ON DIR.ClienteID = CRE.ClienteID
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
				LEFT JOIN CLIENTES CTE
					ON DIR.RelacionadoID = CTE.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona = TipoPersonaMoral
				AND ((DIR.RFC = Var_RFCOficial AND DIR.RFC <> Cadena_Vacia)
					OR
                    (CTE.RFCOficial = Var_RFCOficial AND CTE.RFCOficial <> Cadena_Vacia))
				AND CRE.ClienteID <> Par_ClienteID;

			-- 7 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS DONDE COINCIDA LA DIRECCION DEL CLIENTE SOLICITANTE
            INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		Est_Pend,        	Entero_Cero,

                    "MISMO DOMICILIO",	Cadena_Vacia,		'S',
                    'N',
                    Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion
			FROM CREDITOS CRE
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
				INNER JOIN DIRECCLIENTE DIR
					ON CLI.ClienteID = DIR.ClienteID
				WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
					AND CLI.TipoPersona <> TipoPersonaMoral
					AND DIR.Oficial = 'S'
					AND DIR.EstadoID = Var_EstadoID
					AND DIR.MunicipioID = Var_MunicipioID
					AND DIR.LocalidadID = Var_LocalidadID
					AND DIR.ColoniaID = Var_ColoniaID
					AND DIR.Calle LIKE CONCAT('%',Var_Calle,'%')
					AND DIR.NumeroCasa = Var_NumeroCasa
					AND CRE.ClienteID <> Par_ClienteID;

			-- 8 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS CON DEPENDIENTES ECONOMICO
            -- CON EL MISMO NOMBRE Y APELLIDOS
			INSERT INTO TMP_RIESGOCOMUNCLICRE
            SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,				Par_ProspectoID,	CRE.CreditoID,
					CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		   		Est_Pend,        	Entero_Cero,

                    "DEPENDIENTES ECONOMICOS",	Cadena_Vacia,		'S',
                    'N',
                    Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion
			FROM SOCIODEMODEPEND ECO
				INNER JOIN CREDITOS CRE
					ON ECO.ClienteID = CRE.ClienteID
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
			WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
				AND CLI.TipoPersona <> TipoPersonaMoral
				AND ECO.PrimerNombre = Var_PrimerNombre
				AND ECO.SegundoNombre = Var_SegundoNombre
				AND ECO.TercerNombre = Var_TercerNombre
				AND ECO.ApellidoPaterno = Var_ApellidoPaterno
				AND ECO.ApellidoMaterno = Var_ApellidoMaterno
				AND CRE.ClienteID <> Par_ClienteID;

			-- 9 CONYUGUE QUE SEA CLIENTE Y LOS CLIENTES RELACIONADOS A EL TENGAN CREDITOS VIGENTES, VENCIDOS O CASTIGADOS

			IF(Par_ClienteID = Entero_Cero)THEN
                SET Var_ClienteIDConyu :=(SELECT ClienteConyID FROM SOCIODEMOCONYUG WHERE ProspectoID = Par_ProspectoID);
            ELSE
                SET Var_ClienteIDConyu :=(SELECT ClienteConyID FROM SOCIODEMOCONYUG WHERE ClienteID = Par_ClienteID);
			END IF;

			SET Var_ClienteIDConyu := IFNULL(Var_ClienteIDConyu,Entero_Cero);

            -- SI EL ID ES MAYOR A CERO ES CLIENTE EL CONYUGUE
            IF(Var_ClienteIDConyu > Entero_Cero)THEN

				INSERT INTO TMP_RIESGOCOMUNCLICRE
				SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,				Par_ProspectoID,	CRE.CreditoID,
						CRE.ClienteID, 				CUE.NombreCompleto, 		Entero_Cero,		   		Est_Pend,        	Entero_Cero,

                        "RELACIONADOS CONYUGUE",	Cadena_Vacia,		'S',
                        'N',
						Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,				Aud_NumTransaccion
				FROM  CUENTASAHO AHO
					INNER JOIN CUENTASPERSONA CUE
						ON AHO.CuentaAhoID = CUE.CuentaAhoID
					INNER JOIN CREDITOS CRE
						ON CUE.ClienteID = CRE.ClienteID
				WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
					AND AHO.ClienteID = Var_ClienteIDConyu
					AND AHO.Estatus = 'A'
					AND CUE.ClienteID <> Var_ClienteIDConyu
					AND CRE.ClienteID <> Par_ClienteID;

            END IF;

        END IF;

        -- VALIDACIONES CUANDO EL CLIENTE SOLICITANTE ES PERSONA MORAL
        IF(Var_TipoPersona = TipoPersonaMoral)THEN


            -- 1 CLIENTES PERSONAS MORALES CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS
            -- PERTENENCEN AL MISMO GRUPO EMPRESARRIAL

            IF(Var_GrupoEmpresarial > Entero_Cero)THEN

				INSERT INTO TMP_RIESGOCOMUNCLICRE
				SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,			Par_ClienteID,			Par_ProspectoID,	CRE.CreditoID,
						CLI.ClienteID, 				CLI.NombreCompleto, 	Entero_Cero,		    Est_Pend,           Entero_Cero,
						"GRUPO EMPRESARIAL",	Cadena_Vacia,			'S',
                        'N',
						Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,				Aud_NumTransaccion
				FROM CREDITOS CRE
				INNER JOIN CLIENTES CLI
					ON CRE.ClienteID = CLI.ClienteID
				WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
					AND CLI.TipoPersona = TipoPersonaMoral
					AND CLI.GrupoEmpresarial = Var_GrupoEmpresarial
					AND CRE.ClienteID <> Par_ClienteID;

            END IF;

            -- 2 CLIENTES PERSONAS MORALES CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS
            -- CUYOS DIRECTIVOS COINCIDAN CON LOS DIRECTIVOS DEL CLIENTE SOLICITANTE

            -- CONSULTA EL NUMERO DE DIRECTIVOS DEL CLIENTE SOLICITANTE
			SET Var_NumDirectivos := (SELECT MAX(DirectivoID) FROM DIRECTIVOS WHERE ClienteID = Par_ClienteID);
            SET Var_NumDirectivos := IFNULL(Var_NumDirectivos,Entero_Cero);

            -- SI TIENE DIRECTIVOS RECORREMOS CADA UNO PARA BUSCAR COINCIDENCIAS
            IF(Var_NumDirectivos > Entero_Cero)THEN
				SET Var_AuxInt := Entero_Uno;

                WHILE(Var_AuxInt <= Var_NumDirectivos) DO

                    -- SE OBTIENEN LOS DATOS DEL DIRECTIVO, ENCONTRARA CUANDO EL DIRECTIVO NO SEA CLIENTE
                    SELECT 	 DirectivoID,		PrimerNombre, 					SegundoNombre, 			TercerNombre, 			ApellidoPaterno,
							 ApellidoMaterno,	FechaNac,						RFC,					RelacionadoID
						INTO Var_DirectivoID,	Var_PrimerNombreDir, 			Var_SegundoNombreDir, 	Var_TercerNombreDir, 	Var_ApellidoPaternoDir,
							 Var_ApellidoMaternoDir, Var_FechaNacimientoDir, 	Var_RFCDir,				Var_RelacionadoID
					FROM DIRECTIVOS
                    WHERE ClienteID = Par_ClienteID
						AND DirectivoID = Var_AuxInt;

					-- SI EL DIRECTIVO ES CLIENTE SE CONSULTAN LOS DATOS EN LA TABLA CLIENTES
					IF(Var_RelacionadoID > Entero_Cero)THEN

						SELECT 	 PrimerNombre, 				SegundoNombre, 			TercerNombre, 			ApellidoPaterno,
							 ApellidoMaterno,				FechaNacimiento,		RFCOficial
							INTO Var_PrimerNombreDir, 		Var_SegundoNombreDir, 	Var_TercerNombreDir, 	Var_ApellidoPaternoDir,
								 Var_ApellidoMaternoDir, 	Var_FechaNacimientoDir, Var_RFCDir
						FROM CLIENTES
						WHERE ClienteID = Var_RelacionadoID;

                    END IF;

					SET Var_DirectivoID :=IFNULL(Var_DirectivoID,Entero_Cero);
                    SET Var_PrimerNombreDir :=IFNULL(Var_PrimerNombreDir,Cadena_Vacia);
                    SET Var_SegundoNombreDir :=IFNULL(Var_SegundoNombreDir,Cadena_Vacia);
                    SET Var_TercerNombreDir :=IFNULL(Var_TercerNombreDir,Cadena_Vacia);
                    SET Var_ApellidoPaternoDir :=IFNULL(Var_ApellidoPaternoDir,Cadena_Vacia);

                    SET Var_ApellidoMaternoDir :=IFNULL(Var_ApellidoMaternoDir,Cadena_Vacia);
                    SET Var_FechaNacimientoDir :=IFNULL(Var_FechaNacimientoDir,Fecha_Vacia);
                    SET Var_RFCDir :=IFNULL(Var_RFCDir,Cadena_Vacia);
                    SET Var_RelacionadoID :=IFNULL(Var_RelacionadoID,Entero_Cero);

					IF(Var_DirectivoID > Entero_Cero)THEN

						INSERT INTO TMP_RIESGOCOMUNCLICRE
						SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,					Par_ClienteID,				Par_ProspectoID,	CRE.CreditoID,
								DIR.ClienteID, 				CTE.NombreCompleto, 			Entero_Cero,		  		Est_Pend,        	Entero_Cero,

                                 CASE WHEN DIR.EsAccionista = Cons_Si THEN CONCAT("MISMOS APELLIDOS DIRECTIVOS",' ', PorcentajeAcciones,'%')
                                 ELSE "MISMOS APELLIDOS DIRECTIVOS" END,	Cadena_Vacia,		'S',
                                'N',
								Par_EmpresaID,				Aud_Usuario,					Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
								Aud_Sucursal,				Aud_NumTransaccion
						FROM DIRECTIVOS DIR
							INNER JOIN CREDITOS CRE
								ON DIR.ClienteID = CRE.ClienteID
							INNER JOIN CLIENTES CTE
								ON DIR.ClienteID = CTE.ClienteID
							LEFT JOIN CLIENTES CLI
								ON DIR.RelacionadoID = CLI.ClienteID
						WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
                            AND DIR.ClienteID <> Par_ClienteID
							AND ((DIR.PrimerNombre = Var_PrimerNombreDir
									AND DIR.SegundoNombre = Var_SegundoNombreDir
									AND DIR.TercerNombre = Var_TercerNombreDir
									AND DIR.ApellidoPaterno = Var_ApellidoPaternoDir
									AND DIR.ApellidoMaterno = Var_ApellidoMaternoDir) OR
								(CLI.PrimerNombre = Var_PrimerNombreDir
									AND CLI.SegundoNombre = Var_SegundoNombreDir
									AND CLI.TercerNombre = Var_TercerNombreDir
									AND CLI.ApellidoPaterno = Var_ApellidoPaternoDir
									AND CLI.ApellidoMaterno = Var_ApellidoMaternoDir));

						INSERT INTO TMP_RIESGOCOMUNCLICRE
						SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		   Par_ProspectoID,		CRE.CreditoID,
								DIR.ClienteID, 				CTE.NombreCompleto, 		Entero_Cero,		   Est_Pend,        	Entero_Cero,

                                CASE WHEN DIR.EsAccionista = Cons_Si THEN CONCAT("RFC Y FECHA NACIMIENTO DIRECTIVOS",' ', PorcentajeAcciones,'%')
                                ELSE "RFC Y FECHA NACIMIENTO DIRECTIVOS" END,	Cadena_Vacia,		'S',
                                'N',
								Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
								Aud_Sucursal,				Aud_NumTransaccion
						FROM DIRECTIVOS DIR
							INNER JOIN CREDITOS CRE
								ON DIR.ClienteID = CRE.ClienteID
							INNER JOIN CLIENTES CTE
								ON DIR.ClienteID = CTE.ClienteID
							LEFT JOIN CLIENTES CLI
								ON DIR.RelacionadoID = CLI.ClienteID
						WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
                            AND DIR.ClienteID <> Par_ClienteID
							AND ((DIR.FechaNac = Var_FechaNacimientoDir
									AND DIR.RFC = Var_RFCDir) OR
								(CLI.FechaNacimiento = Var_FechaNacimientoDir
									AND CLI.RFCOficial = Var_RFCDir));

                    END IF;

                    -- 3 CLIENTES PERSONAS FISICAS CON CREDITOS VIGENTES, VENCIDOS O CASTIGADOS DONDE COINCIDAN CON EL DIRECTIVO
					INSERT INTO TMP_RIESGOCOMUNCLICRE
					SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,				Par_ClienteID,		Par_ProspectoID,	CRE.CreditoID,
							CLI.ClienteID, 				CLI.NombreCompleto, 		Entero_Cero,		Est_Pend,        	Entero_Cero,
                            "DIRECTIVOS PF",			Cadena_Vacia,				'S',				'N',				Par_EmpresaID,
                            Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                            Aud_NumTransaccion
					FROM CREDITOS CRE
						INNER JOIN CLIENTES CLI
							ON CRE.ClienteID = CLI.ClienteID
					WHERE CRE.Estatus IN (Credito_Vigente, Credito_Vencido, Credito_Castigado)
						AND CLI.TipoPersona <> TipoPersonaMoral
						AND ((CLI.PrimerNombre = Var_PrimerNombre
							AND CLI.SegundoNombre = Var_SegundoNombre
							AND CLI.TercerNombre = Var_TercerNombre
							AND CLI.ApellidoPaterno = Var_ApellidoPaterno
							AND CLI.ApellidoMaterno = Var_ApellidoMaterno) OR
								(CLI.FechaNacimiento = Var_FechaNacimientoDir AND CLI.RFCOficial = Var_RFCDir))
							AND CRE.ClienteID <> Par_ClienteID;

                    SET Var_AuxInt := Var_AuxInt + Entero_Uno;

                END WHILE;

            END IF;

        END IF;


        -- VALIDACIONES COMO RELACIONADOS DE EMPLEADOS DE LA EMPRESA
         INSERT INTO TMP_RIESGOCOMUNCLICRE
			 SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,		Par_ClienteID,		Par_ProspectoID,		Entero_Cero,
						Entero_Cero,				RP.NombrePersona,	REL.ParentescoID,	Est_Pend,				Entero_Cero,
                        "PERSONA RELACIONADA",				Cadena_Vacia,		'S',				'N' ,	                Par_EmpresaID,
                        Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		    Aud_Sucursal,
                        Aud_NumTransaccion
            FROM RELACIONEMPLEADO REL
            INNER JOIN RELACIONPERSONAS RP
            ON REL.EmpleadoID = RP.PersonaID
			WHERE REL.RFC = Var_RFCOficial;


         -- VALIDACIONES COMO RELACIONADOS DE EMPLEADOS DE LA EMPRESA
         INSERT INTO TMP_RIESGOCOMUNCLICRE
			 SELECT 	Par_SolicitudCreditoID, 	@Num:=@Num+1,		Par_ClienteID,		Par_ProspectoID,		Entero_Cero,
						Entero_Cero,				REL.NombrePersona,	Entero_Cero,		Est_Pend,				Entero_Cero,
                        "PERSONA RELACIONADA",		Cadena_Vacia,		'S',				'N' ,	                Par_EmpresaID,
                        Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		    Aud_Sucursal,
                        Aud_NumTransaccion
            FROM RELACIONPERSONAS REL
			WHERE REL.RFC = Var_RFCOficial;

        -- INSERTA LOS VALORES EN LA TABLA ORIGINAL
        SET @Num := 0;
        INSERT INTO RIESGOCOMUNCLICRE
        	SELECT 	SolicitudCreditoID,	@Num:=@Num+1, ClienteIDSolicitud,	MAX(ProspectoID),	CreditoID,
					ClienteID, 			MAX(NombreCompleto),	MAX(ParentescoID),	MAX(Estatus),		MAX(Clave),
                	Motivo,				MAX(Comentario),		MAX(RiesgoComun),	MIN(Procesado),		Par_EmpresaID,
                    Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	    Aud_Sucursal,
                    Aud_NumTransaccion
            FROM TMP_RIESGOCOMUNCLICRE
            WHERE NumTransaccion=Aud_NumTransaccion
			GROUP BY SolicitudCreditoID,ClienteIDSolicitud,CreditoID,ClienteID,Motivo;

			SET Var_NumRiesgosComun 	:= (SELECT COUNT(SolicitudCreditoID)
												FROM RIESGOCOMUNCLICRE
                                                WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                                                AND Motivo <> DescPersRelacionada);

            SET Var_NumRiesgoPersRel 	:= (SELECT COUNT(SolicitudCreditoID)
											FROM RIESGOCOMUNCLICRE
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                                            AND Motivo = DescPersRelacionada);

			SET Var_NumRiesgosComun		:= IFNULL(Var_NumRiesgosComun,Entero_Cero);
            SET Var_NumRiesgoPersRel	:= IFNULL(Var_NumRiesgoPersRel,Entero_Cero);

			IF(Var_NumRiesgoPersRel > Entero_Cero AND  Var_NumRiesgosComun > Entero_Cero)THEN
				SET     Par_NumErr := 0;
				SET     Par_ErrMen := 'Se encontro riesgo comun posible - Persona Relacionada';
				SET     Var_Control := 'solicitudCreditoID';
			END IF;

            IF(Var_NumRiesgoPersRel > Entero_Cero AND  Var_NumRiesgosComun = Entero_Cero)THEN
				SET     Par_NumErr := 0;
				SET     Par_ErrMen :='Se encontro Persona Relacionada';
				SET     Var_Control := 'solicitudCreditoID';
			END IF;

             IF(Var_NumRiesgoPersRel = Entero_Cero AND Var_NumRiesgosComun > Entero_Cero)THEN
				SET     Par_NumErr := 0;
				SET     Par_ErrMen := 'Se encontro riesgo comun posible';
				SET     Var_Control := 'solicitudCreditoID';
			END IF;

            IF(Var_NumRiesgoPersRel = Entero_Cero AND Var_NumRiesgosComun = Entero_Cero)THEN
				SET     Par_NumErr := 0;
				SET     Par_ErrMen := ' ';
				SET     Var_Control := 'solicitudCreditoID';
            END IF;


        -- BORRAR LOS REGISTROS EN TMP_RIESGOCOMUNCLICRE DE LA SOLICITUD
		DELETE FROM TMP_RIESGOCOMUNCLICRE
        WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
