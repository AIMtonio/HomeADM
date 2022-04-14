-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSTANCIARETCTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETCTEPRO`;
DELIMITER $$


CREATE PROCEDURE `CONSTANCIARETCTEPRO`(
# ============================================================================
# -------------- PROCESO PARA OBTENER LOS DATOS DEL CLIENTE ------------------
# ============================================================================
	Par_Anio			INT(11),			-- Anio Constancia de Retencion
	Par_Mes    			INT(11),			-- Mes Constancia de Retencion

    Par_Salida			CHAR(1),            -- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),			-- Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),  		-- Descripcion de Error

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control     		VARCHAR(100);   	-- Variable de control
	DECLARE	Var_NombreInstit		VARCHAR(150);		-- Almacena el nombre de la institucion
	DECLARE	Var_DireccionInstit		VARCHAR(150);		-- Almacena la direccion de la institucion
	DECLARE	Var_NumInstitucion		INT(11);			-- Almacena el numero de la institucion

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	VARCHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Salida_SI       CHAR(1);

    DECLARE Salida_NO       CHAR(1);
	DECLARE NoProcesado		INT(11);
    DECLARE PersonaFisica	CHAR(1);
	DECLARE PersonaMoral	CHAR(1);
	DECLARE EsRegHacienda	CHAR(1);

    DECLARE EsFiscal		CHAR(1);
    DECLARE EsOficial	    CHAR(1);
    DECLARE DesPerFisica	VARCHAR(10);
	DECLARE DesPerMoral     VARCHAR(10);
    DECLARE PersonaFisAct	CHAR(1);

    DECLARE ConstanteSI		CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- DECIMAL Cero
    SET Salida_SI			:= 'S';             -- Salida Store: SI

    SET Salida_NO        	:= 'N';             -- Salida Store: NO
	SET NoProcesado			:= 1; 				-- Numero No Procesado: 1
    SET PersonaFisica		:= 'F';				-- Tipo Persona: FISICA
	SET PersonaMoral		:= 'M';				-- Tipo Persona: MORAL
	SET EsRegHacienda		:= 'S';				-- Registro Hacienda: SI

    SET EsFiscal		    := 'S';				-- Direccion Fiscal: SI
    SET EsOficial	    	:= 'S';				-- Direccion Oficial: SI
    SET DesPerFisica		:= 'FISICA';		-- Descripcion Tipo Persona: FISICA
	SET DesPerMoral     	:= 'MORAL';			-- Descripcion Tipo Persona: MORAL
    SET PersonaFisAct		:= 'A';				-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL

    SET ConstanteSI			:= 'S';				-- Constante: SI

    ManejoErrores:BEGIN     #bloque para manejar los posibles errores
       DECLARE EXIT HANDLER FOR SQLEXCEPTION
           BEGIN
              SET Par_NumErr  = 999;
              SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETCTEPRO');
              SET Var_Control = 'SQLEXCEPTION';
		END;

        -- Se elimina la tabla temporal
        DELETE FROM TMPDATOSCTECONSTRET;

		-- Se inserta a la tabla temporal los datos del cliente
		INSERT INTO TMPDATOSCTECONSTRET(
			Anio,					Mes,				SucursalID,			NombreSucursalCte,		ClienteID,
			PrimerNombre,			SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
			NombreCompleto,			RazonSocial,		TipoPersona,		RFC,					CURP,
			DireccionCompleta,		RegHacienda,		EsMenorEdad,		EmpresaID,				Usuario,
			FechaActual,			DireccionIP,		ProgramaID,			Sucursal,		    	NumTransaccion)
		SELECT
			Par_Anio, 				Par_Mes,			Cli.SucursalOrigen, 		Cadena_Vacia,		Cli.ClienteID,
			IFNULL(Cli.PrimerNombre,Cadena_Vacia),		IFNULL(Cli.SegundoNombre,	Cadena_Vacia),
            IFNULL(Cli.TercerNombre,Cadena_Vacia),		IFNULL(Cli.ApellidoPaterno,Cadena_Vacia),	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia),
			CASE WHEN TipoPersona IN(PersonaFisica,PersonaFisAct) THEN Cli.NombreCompleto ELSE Cadena_Vacia END,
			CASE WHEN Cli.TipoPersona = PersonaMoral THEN Cli.RazonSocial ELSE Cadena_Vacia END,
			CASE WHEN Cli.TipoPersona = PersonaMoral THEN PersonaMoral ELSE PersonaFisica END,			IFNULL(Cli.RFCOficial,Cadena_Vacia),
			IFNULL(Cli.CURP,Cadena_Vacia),				Cadena_Vacia,		Cli.RegistroHacienda, 		Cli.EsMenorEdad,			Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
            Aud_NumTransaccion
		FROM CLIENTES Cli,
			 CONSTANCIARETENCION Con
		WHERE Cli.ClienteID = Con.ClienteID
        AND Con.Anio = Par_Anio
		GROUP BY Con.ClienteID;

		-- Se actualiza la sucursal origen del cliente
		UPDATE TMPDATOSCTECONSTRET Tmp,
			   SUCURSALES Suc
		SET Tmp.NombreSucursalCte = Suc.NombreSucurs
		WHERE Tmp.SucursalID = Suc.SucursalID;

		-- Se actualiza la direccion del cliente
		UPDATE TMPDATOSCTECONSTRET Tmp,
				DIRECCLIENTE Dir
		SET Tmp.DireccionCompleta = Dir.DireccionCompleta
		WHERE	Tmp.ClienteID	= Dir.ClienteID
		  AND	CASE WHEN Tmp.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END;

		-- Se actualiza la direccion oficial del cliente en caso de no tener una direccion fiscal
		UPDATE TMPDATOSCTECONSTRET Tmp,
				DIRECCLIENTE Dir
		SET Tmp.DireccionCompleta = Dir.DireccionCompleta
		WHERE	Tmp.ClienteID	= Dir.ClienteID
		  AND	Tmp.DireccionCompleta = Cadena_Vacia
		  AND   Dir.Oficial = EsOficial;

		-- Se obtiene el numero de la institucion
		SET	Var_NumInstitucion	:= (SELECT InstitucionID FROM CONSTANCIARETPARAMS);
		SET	Var_NumInstitucion	:= IFNULL(Var_NumInstitucion, Entero_Cero);

		-- Se obtiene el nombre de la institucion
		SET Var_NombreInstit 	:= (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);
		SET	Var_NombreInstit	:= IFNULL(Var_NombreInstit, Cadena_Vacia);

		-- Se obtiene la direccion fical de la institucion
		SET Var_DireccionInstit := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);
		SET	Var_DireccionInstit	:= IFNULL(Var_DireccionInstit, Cadena_Vacia);

        -- Se obtiene la fecha actual
		SET Aud_FechaActual := NOW();

		-- Se inserta la informacion del cliente para generar la constancia de retencion
		INSERT INTO CONSTANCIARETCTE (
			Anio, 					Mes,					SucursalID,				NombreSucursalCte,		ClienteID,
			PrimerNombre,			SegundoNombre,			TercerNombre,			ApellidoPaterno,		ApellidoMaterno,
			NombreCompleto,			RazonSocial, 			TipoPersona, 			RFC,  					CURP,
			DireccionCompleta, 		NombreInstitucion, 		DireccionInstitucion,	FechaGeneracion, 		RegHacienda,
			CadenaCFDI, 			CFDIFechaEmision,		CFDIVersion,			CFDINoCertSAT, 			CFDIUUID,
			CFDIFechaTimbrado, 		CFDISelloCFD, 			CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,
			CFDINoCertEmisor,		Estatus,				MontoTotOperacion,		MontoTotGrav,			MontoTotExent,
			MontoTotRet,			MontoIntReal,			MontoCapital,			EmpresaID,				Usuario,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
		SELECT
			Anio,    				Mes,    				SucursalID,    			NombreSucursalCte,     	ClienteID,
			PrimerNombre, 			SegundoNombre,			TercerNombre,			ApellidoPaterno,		ApellidoMaterno,
			NombreCompleto,			RazonSocial,      		TipoPersona,			RFC,         			CURP,
			DireccionCompleta, 		Var_NombreInstit,  		Var_DireccionInstit, 	CURDATE(),	   	 		RegHacienda,
			Cadena_Vacia,       	Fecha_Vacia,        	Cadena_Vacia,          	Cadena_Vacia,     		Cadena_Vacia,
			Cadena_Vacia, 			Cadena_Vacia, 			Cadena_Vacia,     		Cadena_Vacia, 	    	Cadena_Vacia,
			Cadena_Vacia,			NoProcesado,			Decimal_Cero, 			Decimal_Cero, 			Decimal_Cero,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		    Aud_NumTransaccion
		FROM TMPDATOSCTECONSTRET;

		SET Par_NumErr  	:= Entero_Cero;
		SET Par_ErrMen  	:= 'Proceso para Obtener Informacion de los Clientes Finalizado Exitosamente.';
		SET Var_Control 	:= Cadena_Vacia;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$