-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSAPORTACIONESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSAPORTACIONESMOD`;DELIMITER $$

CREATE PROCEDURE `TIPOSAPORTACIONESMOD`(
# =================================================================
# ----------- SP PARA MODIFICAR LOS TIPOS DE APORTACIONES-----------------
# =================================================================
	Par_TipoAportacionID	INT(11),			-- Tipo de Aportacion a Modificar
    Par_Descripcion			VARCHAR(100),		-- Descripcion de la APORTACION
    Par_FechaCreacion		DATE,				-- Fecha de Creacion
    Par_TasaFV				CHAR(1),			-- Tipo de Aportacion
    Par_Anclaje				VARCHAR(1),			-- Permite Anclaje

    Par_TasaMejorada		VARCHAR(1),    		-- Permite Tasa Mejorada
    Par_EspecificaTasa		VARCHAR(1),    		-- Permite Especificar Tasa
	Par_MonedaID			INT(11),			-- Especifica Moneda
	Par_MinimoApertura		DECIMAL(18,2),		-- Especifica Minimo de Apertura
    Par_MinimoAnclaje		DECIMAL(18,2),    	-- Especifica Minimo de Anclaje

    Par_NumRegistroRECA	    VARCHAR(100),		-- Numero de registro RECA
    Par_FechaInscripcion	DATE,				-- Fecha de inscripcion del RECA
    Par_NombreComercial	    VARCHAR(100),		-- Nombre comercial del producto
	Par_Reinversion			CHAR(1),			-- Especifica si realiza Reinversion Automatica\nS.- Si realiza Reinversion Automatica\nI.-   Indistinto\nN.- No Realiza Reinversion
    Par_Reinvertir          CHAR(3),			-- Indica si hay Reinversion\nC  =  Solo Capital \nCI =  Capital mas interes \nI   =  Indistinto\nN =   No Reliza Inversion.

	Par_DiaInhabil			CHAR(2),			-- Especifica el dia Inhabil
	Par_TipoPagoInt			CHAR(50),			-- Especifica la forma de pago de interes V - Vencimiento, F - Fin de Mes, P -Periodo
	Par_DiasPeriodo			VARCHAR(200),		-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	Par_ClaveCNBV			VARCHAR(10), 		-- Clave registrada en la CNBV

    Par_ClaveCNBVAmpCred	VARCHAR(10),    	-- Clave que amapara creditos
    Par_MaxPuntos			DECIMAL(18,2),		-- Especifica el maximo de puntos
    Par_MinPuntos			DECIMAL(18,2),		-- Especifica el minimo de puntos
	Par_TasaMontoGlobal		CHAR(1),			-- Indica si se selecciona una tasa por el monto conjunto (suma de prod vigentes) que tenga el cliente. N: NO (DEFAULT). S: SI
	Par_IncluyeGpoFam		CHAR(1),			-- Indica que si ademas del monto global del cliente, incluirá los montos de  los miembros de su grupo familiar. N: NO (DEFAULT). S: SI

    Par_DiasPago			VARCHAR(100),		-- Dias de pago de la aportacion
	Par_PagoIntCapitaliza	CHAR(1),			-- capitaliza interes: S=Si, N=No, I=Indistinto

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
    DECLARE Decimal_Cero	DECIMAL(18,2);
    DECLARE Str_NO			CHAR(1);
    DECLARE Cons_PagoProg	CHAR(1);
    DECLARE Cons_CapInte	CHAR(1);

	-- Asignacion de constantes
	SET	NumeroTipo			:= 1;						-- Constante uno
	SET	Cadena_Vacia		:= '';						-- Consatante Vacio
	SET	Entero_Cero			:= 0;						-- Constante Cero
	SET Aud_FechaActual		:= NOW();					-- Fecha Actual
	SET Salida_SI			:= 'S';						-- Constante SI
	SET Fecha_Vacia     	:= '1900-01-01';            -- Constante Fecha vacia
	SET PagoIntPeriodo		:= 'P';						-- Constante Forma de pago interes Periodo
	SET PagoIntMes			:= 'F';						-- Constante forma de pago interes fin de mes
    SET Decimal_Cero		:= 0.00;					-- Constante DECIMAL cero
	SET Str_NO				:= 'N';						-- Constante no.
    SET Cons_PagoProg		:= 'E';						-- Constante Forma de pago interes Programado
    SET Cons_CapInte		:= 'I';						-- Capitaliza interes: Indistinto

	 ManejoErrores:BEGIN
		 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := '999';
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOSAPORTACIONESMOD');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;


		IF(NOT EXISTS(SELECT TipoAportacionID
					FROM TIPOSAPORTACIONES
					WHERE TipoAportacionID = Par_TipoAportacionID)) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Numero de Tipo de Aportacion no Existe.';
			SET Var_Control:= 'tipoAportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MonedaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := 'El Tipo de Moneda esta Vacio.' ;
			SET Var_Control:=  'monedaSelect' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Reinversion,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := 'El tipo de Reinversion esta Vacio.' ;
			SET Var_Control:=  'reinvertir1' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoPagoInt,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := 'La Forma de pago de Interes esta Vacia.' ;
			SET Var_Control:= 'tipoPagoInt' ;
			LEAVE ManejoErrores;
		END IF;

        IF LOCATE(PagoIntPeriodo, Par_TipoPagoInt)> Entero_Cero THEN
			IF(IFNULL(Par_DiasPeriodo,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 014;
				SET Par_ErrMen := 'El Numero de Dias del Periodo Esta Vacio.' ;
				SET Var_Control:= 'diasPeriodo' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF ((LOCATE(PagoIntPeriodo, Par_TipoPagoInt)> Entero_Cero)OR(LOCATE(PagoIntMes, Par_TipoPagoInt)> Entero_Cero)) THEN
			IF(IFNULL(Par_PagoIntCal,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 015;
				SET Par_ErrMen := 'El Tipo de pago de Interes esta Vacio.' ;
				SET Var_Control:= 'pagoIntCal' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF LOCATE(Cons_PagoProg, Par_TipoPagoInt)> Entero_Cero THEN
			IF(IFNULL(Par_DiasPago,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 016;
				SET Par_ErrMen := 'El Numero de Dias de Pago Esta Vacio.' ;
				SET Var_Control:= 'diasPago' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_ClaveCNBV 			:=  IFNULL(Par_ClaveCNBV,Cadena_Vacia);
		SET Par_ClaveCNBVAmpCred 	:=  IFNULL(Par_ClaveCNBVAmpCred,Cadena_Vacia);
        SET Par_MaxPuntos 			:=  IFNULL(Par_MaxPuntos,Decimal_Cero);
		SET Par_MinPuntos 			:=  IFNULL(Par_MinPuntos,Decimal_Cero);
		SET Par_TasaMontoGlobal 	:=  IFNULL(Par_TasaMontoGlobal,Str_NO);
        SET Par_DiasPago			:=  IFNULL(Par_DiasPago,Cadena_Vacia);
        SET Par_PagoIntCapitaliza	:=  IFNULL(Par_PagoIntCapitaliza,Cons_CapInte);

		UPDATE TIPOSAPORTACIONES SET
			Descripcion	 	    = Par_Descripcion,
			FechaCreacion	    = Par_FechaCreacion,
			TasaFV			    = Par_TasaFV,
			Anclaje			    = Par_Anclaje,
			TasaMejorada	    = Par_TasaMejorada,

			EspecificaTasa	    = Par_EspecificaTasa,
			MonedaID		    = Par_MonedaID,
			MinimoApertura	    = Par_MinimoApertura,
			MontoMinimoAnclaje	= Par_MinimoAnclaje,
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

            MaxPuntos			= Par_MaxPuntos,
            MinPuntos			= Par_MinPuntos,
            TasaMontoGlobal		= Par_TasaMontoGlobal,
            IncluyeGpoFam		= Par_IncluyeGpoFam,
            DiasPago			= Par_DiasPago,

            PagoIntCapitaliza	= Par_PagoIntCapitaliza,
			EmpresaID		    = Par_EmpresaID,

			Usuario			    = Aud_Usuario,
			FechaActual 	    = Aud_FechaActual,
			DireccionIP 	    = Aud_DireccionIP,
			ProgramaID 	        = Aud_ProgramaID,
			Sucursal		    = Aud_Sucursal,

			NumTransaccion	    = Aud_NumTransaccion
		WHERE TipoAportacionID 	= Par_TipoAportacionID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Tipo de Aportacion Modificado Exitosamente: ',CONVERT(Par_TipoAportacionID,CHAR)) ;
		SET Var_Control:= 'tipoAportacionID' ;
		SET Var_Consecutivo=Par_TipoAportacionID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$