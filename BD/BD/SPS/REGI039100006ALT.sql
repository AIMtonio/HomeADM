-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGI039100006ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGI039100006ALT`;DELIMITER $$

CREATE PROCEDURE `REGI039100006ALT`(
/************************************************************************
--------- SP QUE AGREGA UN REGISTRO PARA EL REGULATORIO I0391 SOCAP -----
************************************************************************/
    Par_Anio            INT,			-- Ano del reporte
    Par_Mes             INT, 			-- Mes del reporte
	Par_Entidad			VARCHAR(150), 	-- Clave de la Entidad
    Par_Emisora			VARCHAR(7), 	-- Clave de la Emisora
    Par_Serie			VARCHAR(10),   	-- Clave del Numero de Serie

    Par_FormaAdqui		VARCHAR(5), 	-- Id de la Forma de Adquisicion
    Par_TipoInstru		VARCHAR(5), 	-- Id del tipo de instrumento
    Par_ClasfConta		VARCHAR(12), 	-- Clasificiacion contable
    Par_FechaContra		VARCHAR(8), 	-- Fecha de Contratacion
    Par_FechaVencim		VARCHAR(8), 	-- Fecha de Vencimiento

    Par_NumeroTitu		VARCHAR(21), 	-- Numero de titulo
    Par_CostoAdqui		VARCHAR(21), 	-- Costo de Adquisicion
    Par_TasaInteres		VARCHAR(16), 	-- Tasa de Interes
    Par_GrupoRiesgo		VARCHAR(5), 	-- Grupo de Riesgo
    Par_Valuacion		VARCHAR(21), 	-- Valuacion

    Par_ResValuacion 	VARCHAR(21), 	-- Resultado de valuacion
    Par_TipoInstitucion INT, 			-- Tipo de Institucion
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),
	Aud_Empresa		    INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,

	Aud_NumTransaccion	BIGINT

	)
TerminaStore: BEGIN
-- Declaracion de Variables
DECLARE Var_Control		CHAR(100);
DECLARE Var_Periodo     VARCHAR(6);
DECLARE Var_Financiera  VARCHAR(8);		-- Variable para validar que una entidad financiera existe
DECLARE Var_Consecutivo	INT;
DECLARE Var_TipoValorID	INT;

-- Declaracion de Constantes
DECLARE SalidaSI		CHAR(1);
DECLARE Entero_Cero		INT;
DECLARE Cadena_Vacia	CHAR;
DECLARE Var_Subreporte  VARCHAR(6);
DECLARE Var_Entidad		VARCHAR(6);
DECLARE Entero_Ocho     INT;           -- Li­mite de 8 caracteres para el ID de la Entidad

-- Asignacion de Constantes
SET SalidaSI		:= 'S';
SET Entero_Cero		:= 0;
SET Cadena_Vacia	:= '';
SET Par_NumErr		:= 1;
SET Par_ErrMen		:= Cadena_Vacia;
SET Var_Subreporte  := '0391';
SET Entero_Ocho     := 8;
SET Var_Control		:= '';

SELECT ClaveEntidad INTO Var_Entidad FROM PARAMETROSSIS WHERE EmpresaID = Aud_Empresa;

 ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REGI039100006ALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

    IF(Par_Mes < 10) THEN
		SET Var_Periodo    :=  CONCAT(Par_Anio,'0',Par_Mes);
	ELSE
		SET Var_Periodo    :=  CONCAT(Par_Anio,Par_Mes);
    END IF;

    SELECT (COUNT(*)+1) INTO Var_Consecutivo FROM
    `HIS-REGULATORIOI0391` WHERE Anio = Par_Anio
    AND Mes = Par_Mes
    AND TipoInstitucionID = Par_TipoInstitucion;

    SET Var_Consecutivo = IFNULL(Var_Consecutivo,Entero_Cero);

	IF (IFNULL(Par_Anio,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'El Ano esta vacio';
        SET Var_Control	:= 'anio';
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_Mes,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'El Mes esta vacio';
        SET Var_Control	:= 'mes';
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_Entidad,Entero_Cero)=Cadena_Vacia)THEN
		SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'El Numero de Entidad esta vacio';
        SET Var_Control	:= CONCAT('entidad',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

     IF (LENGTH(IFNULL(Par_Entidad,Cadena_Vacia))>Entero_Ocho)THEN
		SET Par_NumErr  := 4;
        SET Par_ErrMen  := 'El Numero de Entidad tiene mas de 8 caracteres';
        SET Var_Control	:= CONCAT('entidad',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    SELECT CodigoOpcion INTO Var_Financiera FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_Entidad AND MenuID = 1;

    IF (IFNULL(Var_Financiera,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 5;
        SET Par_ErrMen  := 'El Numero de Entidad es invalido';
        SET Var_Control	:= CONCAT('entidad',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_Emisora,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 18;
        SET Par_ErrMen  := 'La Emisora esta vacia';
        SET Var_Control	:= CONCAT('emisora',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;


    IF (IFNULL(Par_Serie,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 6;
        SET Par_ErrMen  := 'La Serie esta vacia';
        SET Var_Control	:= CONCAT('serie',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;


    IF (IFNULL(Par_FormaAdqui,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 7;
        SET Par_ErrMen  := 'La Forma de Adquisicion esta vacia';
        SET Var_Control	:= CONCAT('formaAdqui',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;



    IF (IFNULL(Par_TipoInstru,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 8;
        SET Par_ErrMen  := 'El Tipo de Instrumento esta vacio';
        SET Var_Control	:= CONCAT('tipoInstru',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_ClasfConta,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 9;
        SET Par_ErrMen  := 'La Clasificacion Contable esta vacia';
        SET Var_Control	:= CONCAT('clasfConta',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_FechaContra,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 10;
        SET Par_ErrMen  := 'La Fecha de Contratacion esta vacia';
        SET Var_Control	:= CONCAT('fechaContra',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_FechaVencim,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 11;
        SET Par_ErrMen  := 'La Fecha de Vencimiento esta vacia';
        SET Var_Control	:= CONCAT('fechaVencim',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_NumeroTitu,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 12;
        SET Par_ErrMen  := 'El Numero de Ti­tulo esta vacio';
        SET Var_Control	:= CONCAT('numeroTitu',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_CostoAdqui,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 13;
        SET Par_ErrMen  := 'El Costo de Adquisicion esta vacio';
        SET Var_Control	:= CONCAT('costoAdqui',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_TasaInteres,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 14;
        SET Par_ErrMen  := 'La Tasa de Interes esta vacia';
        SET Var_Control	:= CONCAT('tasaInteres',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_GrupoRiesgo,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 15;
        SET Par_ErrMen  := 'El Grupo de Riesgo esta vacio';
        SET Var_Control	:= CONCAT('grupoRiesgo',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_Valuacion,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 16;
        SET Par_ErrMen  := 'La Valuacion Directa esta vacia';
        SET Var_Control	:= CONCAT('valuacion',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_ResValuacion,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 17;
        SET Par_ErrMen  := 'El Resultado por Valuacion esta vacio';
        SET Var_Control	:= CONCAT('resValuacion',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;

    IF (IFNULL(Par_TipoInstitucion,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr  := 21;
        SET Par_ErrMen  := 'El Tipo de Institucion esta Vacio';
        SET Var_Control	:= 'institucionID';
        LEAVE ManejoErrores;
	END IF;


	INSERT INTO `HIS-REGULATORIOI0391`(
		ClaveEntidad,	Subreporte,		Anio,			Mes,			Entidad,
		Emisora,		Serie,	    	FormaAdqui,		TipoInstru,		ClasfConta,
		FechaContra,	FechaVencim,    NumeroTitu,		CostoAdqui,		TasaInteres,
		GrupoRiesgo,	Valuacion,	    ResValuacion,	EmpresaID,		Usuario,
		FechaActual,	DireccionIP,    ProgramaID,		Sucursal,		NumTransaccion,
		Periodo,		Consecutivo,	TipoValorID,	TipoInversion,	TipoInstitucionID
    )
    VALUES(
		Var_Entidad,		Var_Subreporte,		Par_Anio,				Par_Mes,				Par_Entidad,
		Par_Emisora,		Par_Serie,		    Par_FormaAdqui,			Par_TipoInstru,			Par_ClasfConta,
		Par_FechaContra,	Par_FechaVencim,	Par_NumeroTitu,			Par_CostoAdqui,			Par_TasaInteres,
		Par_GrupoRiesgo,	Par_Valuacion, 	    Par_ResValuacion,		Aud_Empresa,			Aud_Usuario,
		NOW(),	Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion,
		Var_Periodo,		Var_Consecutivo,	Cadena_Vacia,			Cadena_Vacia,		Par_TipoInstitucion
    );

    SET Par_NumErr  := 0;
	SET Par_ErrMen  := 'Registro agregado exitosamente';

END ManejoErrores;  -- END del Handler de Errores
 IF (Par_Salida = SalidaSI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
 END IF;

END TerminaStore$$