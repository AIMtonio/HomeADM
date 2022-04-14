-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMATRIZRIESGOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMATRIZRIESGOACT`;DELIMITER $$

CREATE PROCEDURE `CATMATRIZRIESGOACT`(
-- SP Para actualizar los valores de la matriz de riesgo PLD
	Par_PEPNacional					SMALLINT(6),	-- ES PEP Nacional, Publico (Consanguineo, afinidad )
	Par_PEPExtranejero        		SMALLINT(6),	-- ES PEP Extranjero, Publico (Consanguineo, afinidad )
	Par_Localidad         			SMALLINT(6),	-- Localidad Considerada de Alto Riesgo
	Par_ActEconomica				SMALLINT(6),	-- La actividad es Considerada de Alto RiesgO
	Par_OrigenRecursos        		SMALLINT(6),	-- El Origen de los Recursos es de un Tercero

	Par_ProdCredito					SMALLINT(6),	-- El producto de credito es de Alto Riesgo
	Par_DestCredito					SMALLINT(6),	-- El Destino o aplicacion del Crédito es considerado de Alto Riesgo
	Par_LiAlertInusualesMesVal    	SMALLINT(6),	-- Valor de alertas inusuales para ser considerado alto riesgo
	Par_LiAlertInusualesMesLimite	SMALLINT(6),	-- Valor de alertas inusuales para ser considerado alto riesgo
	Par_LiOperRelevMesVal     		SMALLINT(6),	-- Limite de alertas inusuales para ser considerado alto riesgo

	Par_LiOperRelevMesLimite		SMALLINT(6),	-- Limite de alertas inusuales para ser considerado alto riesgo
	Par_PaisNacimiento				SMALLINT(6),	-- País Considerado de Alto Riesgo
	Par_PaisResidencia				SMALLINT(6),	-- País Considerado de Alto Riesgo
	Par_Salida            			CHAR(1),		-- El sp genera una salida
	INOUT Par_NumErr          		INT(11),		-- Parametro de salida con numero de error

	INOUT Par_ErrMen          		VARCHAR(200),	-- Parametro de salida con el mensaje de error
	/* Parametros de Auditoria */
	Par_EmpresaID             		INT(11),
	Aud_Usuario               		INT(11),
	Aud_FechaActual           		DATETIME,
	Aud_DireccionIP           		VARCHAR(15),

	Aud_ProgramaID            		VARCHAR(50),
	Aud_Sucursal              		INT(11),
	Aud_NumTransaccion        		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Control      			VARCHAR(50);   -- Control
-- Declaracion de constantes

DECLARE Act_PEPNacional				TINYINT;
DECLARE Act_PEPExtranejero			TINYINT;
DECLARE Act_Localidad				TINYINT;
DECLARE Act_ActEconomica			TINYINT;
DECLARE Act_OrigenRecursos			TINYINT;
DECLARE Act_ProdCredito				TINYINT;
DECLARE Act_DestCredito				TINYINT;
DECLARE Act_LiAlertInusualesMes		TINYINT;
DECLARE Act_LiOperRelevMes			TINYINT;
DECLARE Act_PaisNacimiento			TINYINT;
DECLARE Act_PaisResidencia			TINYINT;

DECLARE NuevoCodigoMatriz		INT(11);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Entero_Cero				INT;
DECLARE SalidaSI				CHAR(1);
DECLARE SalidaNO				CHAR(1);
DECLARE Clientes_Activos		INT;

-- Asignacon de constantes
SET Act_PEPNacional			:= 1;			-- Actualizacio PEP nacional
SET Act_PEPExtranejero		:= 2;			-- Actualizacion PEP extranjero
SET Act_Localidad			:= 3;			-- Actualizacion localidad
SET Act_ActEconomica      	:= 4;			-- Actualizacion actividad economica
SET Act_OrigenRecursos     	:= 5;			-- Actualizacion origen de recursos
SET Act_ProdCredito       	:= 6;			-- Actualizacion producto de credito
SET Act_DestCredito       	:= 7;			-- Actualizacion destino de credito
SET Act_LiAlertInusualesMes	:= 8;			-- Limite de operaciones inusuales por mes para ser considerado de alto riego
SET Act_LiOperRelevMes		:= 9;			-- Limite de operaciones inusuales por mes para ser considerado de alto riego
SET Act_PaisNacimiento		:= 10;			-- Actualizacion Pais Nacimiento
SET Act_PaisResidencia		:= 11;			-- Actualizacion Pais Residencia
SET NuevoCodigoMatriz     	:= (SELECT CodigoMatriz FROM CATMATRIZRIESGO LIMIT 1)+1;  -- Se actualiza el codigo de la matrz
SET Cadena_Vacia          	:='' ;			-- Cadena o string vacio
SET Entero_Cero           	:= 0 ;			-- Entero en cero
SET SalidaSI              	:='S';			-- El Store SI genera una Salida
SET SalidaNO              	:='N';			-- El Store NO genera una Salida
SET Clientes_Activos		:=1;			-- Para Actualizar Clientes Activos

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
          BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-CATMATRIZRIESGOACT');
            SET Var_Control = 'sqlException' ;
          END;

    IF(IFNULL(Par_PEPNacional , Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para PEP Nacional';
        SET Var_Control := 'pepNacional';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PEPExtranejero , Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para PEP Extranjero';
        SET Var_Control := 'pepExtranjero';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Localidad, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 003;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Localidad';
        SET Var_Control := 'localidad';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ActEconomica, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 004;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para Actividad Economica';
        SET Var_Control := 'actEconomica';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_OrigenRecursos, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 005;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para Origen de Recursos';
        SET Var_Control := 'origenRecursos';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ProdCredito, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 006;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para El Producto de Credito';
        SET Var_Control := 'productoCredito';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_DestCredito, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 007;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para El Producto de Credito';
        SET Var_Control := 'destinoCredito';
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_LiAlertInusualesMesVal, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 008;
        SET Par_ErrMen  := 'Proporcione un Valor Valido de Alertas Inusuales Mes';
        SET Var_Control := 'limiteAlertasInuales';
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_LiOperRelevMesVal, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 009;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Para Op. Inusuales Mes';
        SET Var_Control := 'limiteOperInusuales';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LiAlertInusualesMesLimite, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 008;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Limite de Alertas Inusuales Mes';
        SET Var_Control := 'limiteAlertasInuales';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LiOperRelevMesLimite, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 009;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Limite Por Op. Inusuales Mes';
        SET Var_Control := 'limiteOperInusuales';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PaisNacimiento, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 10;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Pais Nacimiento.';
        SET Var_Control := 'limiteOperInusuales';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PaisResidencia, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 11;
        SET Par_ErrMen  := 'Proporcione un Valor Valido Pais Residencia.';
        SET Var_Control := 'limiteOperInusuales';
        LEAVE ManejoErrores;
    END IF;

    # Inserta en el historico de matriz antes de actualizar
	INSERT INTO HISCATMATRIZRIESGO(
		CodigoMatriz,	ConceptoMatrizID,	Concepto,		Descripcion,		Valor,
		LimiteValida,	Grupo,				EmpresaID,		Usuario,			FechaActual,
		DireccionIP,	ProgramaID,			Sucursal,		NumTransaccion)
	SELECT
		CodigoMatriz,	ConceptoMatrizID,	Concepto,		Descripcion,		Valor,
		LimiteValida,	Grupo,				EmpresaID,		Usuario,			FechaActual,
		DireccionIP,	ProgramaID,			Sucursal,		NumTransaccion
	  FROM CATMATRIZRIESGO;

	# Realiza la actualizacion de la matriz dependiendo del concepto
	UPDATE CATMATRIZRIESGO SET
		Valor = Par_PEPNacional
	WHERE ConceptoMatrizID  = Act_PEPNacional;

	UPDATE CATMATRIZRIESGO SET
		Valor = Par_PEPExtranejero
	WHERE ConceptoMatrizID  = Act_PEPExtranejero;

	UPDATE CATMATRIZRIESGO SET
		Valor = Par_Localidad
	WHERE ConceptoMatrizID  = Act_Localidad;

	UPDATE CATMATRIZRIESGO SET
		Valor = Par_ActEconomica
	WHERE ConceptoMatrizID  = Act_ActEconomica;

	UPDATE CATMATRIZRIESGO SET
		Valor = Par_OrigenRecursos
	WHERE ConceptoMatrizID  = Act_OrigenRecursos;

	UPDATE CATMATRIZRIESGO SET
		Valor = Par_ProdCredito
	WHERE ConceptoMatrizID  = Act_ProdCredito;

	UPDATE CATMATRIZRIESGO SET
		Valor = Par_DestCredito
	WHERE ConceptoMatrizID  = Act_DestCredito;

	UPDATE CATMATRIZRIESGO SET
		Valor 			= Par_LiAlertInusualesMesVal,
		LimiteValida 	= Par_LiAlertInusualesMesLimite
	WHERE ConceptoMatrizID  = Act_LiAlertInusualesMes;

	UPDATE CATMATRIZRIESGO SET
		Valor 			= Par_LiOperRelevMesVal,
		LimiteValida 	= Par_LiOperRelevMesLimite
	WHERE ConceptoMatrizID = Act_LiOperRelevMes;

	UPDATE CATMATRIZRIESGO SET
		Valor		 	= Par_PaisNacimiento
	WHERE ConceptoMatrizID = Act_PaisNacimiento;

	UPDATE CATMATRIZRIESGO SET
		Valor		 	= Par_PaisResidencia
	WHERE ConceptoMatrizID = Act_PaisResidencia;

	SET Aud_FechaActual := NOW();

	#Actualiza los campos de auditoria y el codigo de la matriz
	UPDATE CATMATRIZRIESGO SET
		CodigoMatriz		= NuevoCodigoMatriz,
		EmpresaID			= Par_EmpresaID,
		Usuario				= Aud_Usuario,
		FechaActual			= Aud_FechaActual,
		DireccionIP			= Aud_DireccionIP,
		ProgramaID			= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion		= Aud_NumTransaccion;

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := 'Matriz de Riesgos Actualizada Exitosamente';
	SET Var_Control := 'codigoMatrizID';

END ManejoErrores;  -- END del Handler de Errores

    IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero  AS Consecutivo;
    END IF;

END TerminaStore$$