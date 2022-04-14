-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCEDESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCEDESMOD`;
DELIMITER $$


CREATE PROCEDURE `TIPOSCEDESMOD`(
# =================================================================
# ----------- SP PARA MODIFICAR LOS TIPOS DE CEDES-----------------
# =================================================================
	Par_TipoCedeID			INT(11),			-- Tipo de Cede a Modificar
    Par_Descripcion			VARCHAR(100),		-- Descripcion de la CEDE
    Par_FechaCreacion		DATE,				-- Fecha de Creacion
    Par_TasaFV				CHAR(1),			-- Tipo de CEDE
    Par_Anclaje				VARCHAR(1),			-- Permite Anclaje

    Par_TasaMejorada		VARCHAR(1),    		-- Permite Tasa Mejorada
    Par_EspecificaTasa		VARCHAR(1),    		-- Permite Especificar Tasa
	Par_MonedaID			INT(11),			-- Especifica Moneda
	Par_MinimoApertura		DECIMAL(18,2),		-- Especifica Minimo de Apertura
    Par_MinimoAnclaje		DECIMAL(18,2),    	-- Especifica Minimo de Anclaje

    Par_Genero				VARCHAR(4),			-- Especifica Genero
    Par_EstadoCivil			VARCHAR(100),    	-- Especifica Estado Civil
    Par_MinimoEdad			INT(11),    		-- Especifica Minimo de Edad
    Par_MaximoEdad			INT(11),   			-- Especifica Maximo de Edad
    Par_ActividadEcon		VARCHAR(750),		-- Especifica Actividades

    Par_NumRegistroRECA	    VARCHAR(100),
    Par_FechaInscripcion	DATE,
    Par_NombreComercial	    VARCHAR(100),
	Par_Reinversion			CHAR(1),
    Par_Reinvertir          CHAR(3),			-- Permite Reinversion

	Par_DiaInhabil			CHAR(2),			-- Especifica el dia Inhabil
	Par_TipoPagoInt			CHAR(50),			-- Especifica la forma de pago de interes V - Vencimiento, F - Fin de Mes, P -Periodo
	Par_DiasPeriodo			VARCHAR(200),		-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	Par_ClaveCNBV			VARCHAR(10), 		-- Clave registrada en la CNBV
    Par_ClaveCNBVAmpCred	VARCHAR(10),    	-- Clave que amapara creditos

    Par_Salida				CHAR(1),			-- Especifica Salia
    INOUT	Par_NumErr		INT(11),			-- INOUT NumErr
    INOUT	Par_ErrMen		VARCHAR(400),    	-- INOUT ErrMen

    Par_EmpresaID			INT(11),			-- Parametro de Auditoria
    Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	NumeroTipo		INT(11);
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(11);
	DECLARE Salida_SI		CHAR(1);
	DECLARE Var_Control		VARCHAR(350);
	DECLARE Var_Consecutivo	INT(11);
	DECLARE Fecha_Vacia     DATE;
    DECLARE PagoIntPeriodo	CHAR(1);
    DECLARE PagoIntMes		CHAR(1);
    DECLARE Estatus_Inactivo		CHAR(1);					-- Estatus Inactivo

	DECLARE Var_EstatusTipoCede		CHAR(2);				-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);			-- Descripcion Tipo Cede


	-- Asignacion de constantes
	SET	NumeroTipo			:= 1;						-- Constante uno
	SET	Cadena_Vacia		:= '';						-- Consatante Vacio
	SET	Entero_Cero			:= 0;						-- Constante Cero
	SET Aud_FechaActual		:= NOW();					-- Fecha Actual
	SET Salida_SI			:= 'S';						-- Constante SI
	SET Fecha_Vacia     	:= '1900-01-01';            -- Constante Fecha vacia
	SET PagoIntPeriodo		:= 'P';						-- Constante Forma de pago interes Periodo
	SET PagoIntMes			:= 'F';						-- Constante forma de pago interes fin de mes
    SET Estatus_Inactivo	:= 'I';

	 ManejoErrores:BEGIN
		 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOSCEDESMOD');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;

        SELECT		Estatus,				Descripcion
			INTO 	Var_EstatusTipoCede,	Var_Descripcion
			FROM 	TIPOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;

		IF(NOT EXISTS(SELECT TipoCedeID
					FROM TIPOSCEDES
					WHERE TipoCedeID = Par_TipoCedeID)) THEN
			SET Par_NumErr = 001;
			SET Par_ErrMen = 'El Numero de Tipo de CEDE no Existe.';
			SET Var_Control= 'tipoCedeID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Genero,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr = 02;
			SET Par_ErrMen = 'El Genero esta Vacio.' ;
			SET Var_Control=  'genero' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EstadoCivil,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr = 003;
			SET Par_ErrMen = 'El Estado Civil esta Vacio.' ;
			SET Var_Control=  'estadoCivil' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MinimoEdad,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr = 004;
			SET Par_ErrMen = 'El Minimo de Edad esta Vacio.' ;
			SET Var_Control=  'minimoEdad' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MaximoEdad,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr = 005;
			SET Par_ErrMen = 'El Maximo de Edad esta Vacio.' ;
			SET Var_Control=  'maximoEdad' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MonedaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr = 011;
			SET Par_ErrMen = 'El Tipo de Moneda esta Vacio.' ;
			SET Var_Control=  'monedaSelect' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Reinversion,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr = 012;
			SET Par_ErrMen = 'El tipo de Reinversion esta Vacio.' ;
			SET Var_Control=  'reinvertir1' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoPagoInt,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr = 013;
			SET Par_ErrMen = 'La Forma de pago de Interes esta Vacia.' ;
			SET Var_Control= 'tipoPagoInt' ;
			LEAVE ManejoErrores;
		END IF;

        IF LOCATE(PagoIntPeriodo, Par_TipoPagoInt)> Entero_Cero THEN
			IF(IFNULL(Par_DiasPeriodo,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr = 014;
				SET Par_ErrMen = 'El Numero de Dias del Periodo Esta Vacio.' ;
				SET Var_Control= 'diasPeriodo' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF ((LOCATE(PagoIntPeriodo, Par_TipoPagoInt)> Entero_Cero)OR(LOCATE(PagoIntMes, Par_TipoPagoInt)> Entero_Cero)) THEN
			IF(IFNULL(Par_PagoIntCal,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr = 015;
				SET Par_ErrMen = 'El Tipo de pago de Interes esta Vacio.' ;
				SET Var_Control= 'pagoIntCal' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
			SET Par_NumErr	:=	016;
			SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:=	'tipoCedeID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClaveCNBV 			:=  IFNULL(Par_ClaveCNBV,Cadena_Vacia);
		SET Par_ClaveCNBVAmpCred 	:=  IFNULL(Par_ClaveCNBVAmpCred,Cadena_Vacia);

		UPDATE TIPOSCEDES SET
			Descripcion	 	    = Par_Descripcion,
			FechaCreacion	    = Par_FechaCreacion,
			TasaFV			    = Par_TasaFV,
			Anclaje			    = Par_Anclaje,
			TasaMejorada	    = Par_TasaMejorada,

			EspecificaTasa	    = Par_EspecificaTasa,
			MonedaID		    = Par_MonedaID,
			MinimoApertura	    = Par_MinimoApertura,
			MontoMinimoAnclaje	= Par_MinimoAnclaje,

			Genero			    = Par_Genero,
			EstadoCivil		    = Par_EstadoCivil,
			MinimoEdad		    = Par_MinimoEdad,
			MaximoEdad		    = Par_MaximoEdad,
			ActividadEcon	    = Par_ActividadEcon,

            NumRegistroRECA     = Par_NumRegistroRECA,
			FechaInscripcion    = Par_FechaInscripcion,
			NombreComercial     = Par_NombreComercial,
			Reinversion			= Par_Reinversion,
			Reinvertir	        = Par_Reinvertir,

            DiaInhabil			= Par_DiaInhabil,
            TipoPagoInt			= Par_TipoPagoInt,
            DiasPeriodo			= Par_DiasPeriodo,
            PagoIntCal			= Par_PagoIntCal,
            ClaveCNBV			= Par_ClaveCNBV,
            ClaveCNBVAmpCred	= Par_ClaveCNBVAmpCred,

			EmpresaID		    = Par_EmpresaID,
			Usuario			    = Aud_Usuario,
			FechaActual 	    = Aud_FechaActual,
			DireccionIP 	    = Aud_DireccionIP,
			ProgramaID 	        = Aud_ProgramaID,
			Sucursal		    = Aud_Sucursal,
			NumTransaccion	    = Aud_NumTransaccion
		WHERE TipoCedeID 		= Par_TipoCedeID;

		SET Par_NumErr = 000;
		SET Par_ErrMen = CONCAT('Tipo de CEDES Modificado Exitosamente: ',CONVERT(Par_TipoCedeID,CHAR)) ;
		SET Var_Control= 'tipoCedeID' ;
		SET Var_Consecutivo=Par_TipoCedeID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$