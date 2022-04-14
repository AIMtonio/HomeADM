-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREFONDEOWSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREFONDEOWSACT`;
DELIMITER $$

CREATE PROCEDURE `CREFONDEOWSACT`(
# ================================================================
# ------ STORE para etiquetar la cartera de fondeadores -------
# ================================================================
    Par_CreditoID			BIGINT(12),				-- Numero de Creditos, separados por coma
	Par_InstitutFondeoID	INT(11),			-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
    Par_Etiqueta			CHAR(1),			-- Etiqueta del credito
    
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE	Var_AdFiMa			CHAR(1);  -- Valor B  es ADMINISTRADOR DEL FIDEICOMISO MAESTRO	

-- DECLARACION DE VARIABLES 
DECLARE Var_InstitFondeoID  INT;
DECLARE Var_CreditoID    	BIGINT(12);
DECLARE Var_TipoFondeador   CHAR(1);
DECLARE Var_FechaSistema	DATE;			-- Almacena la Fecha del Sistema
DECLARE Var_FecActualiza	DATE;			-- Almacena la Fecha del Sistema
DECLARE	Par_NumErr 			INT(11);				
DECLARE	Par_ErrMen 			VARCHAR(400);	
DECLARE Var_Etiqueta		CHAR(1);
DECLARE Var_EtiquetaAFM		CHAR(1);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Par_NumErr			:= 000000;
SET Par_ErrMen			:= 'Etiqueta Asignada Exitosamente' ;
SET Var_AdFiMa       	:= 'B';

-- ASIGNACION DE VARIABLES 
SET Var_FechaSistema	:= now();
SET Var_FecActualiza	:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr  := 999;
		SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-RELCREDPASIVOWSACT');
	END;

	IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 000001;
		SET Par_ErrMen := 'El numero de credito esta vacio.';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_InstitutFondeoID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 000002;
		SET Par_ErrMen := 'La institucion de fondeo esta vacia.';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_Etiqueta, Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr := 000003;
		SET Par_ErrMen := 'La etiqueta esta vacia.';
	END IF;


	SELECT 	InstitFondeoID, 	CreditoID,		EtiquetaFondeo,  EtiquetaAFM into  
			Var_InstitFondeoID, Var_CreditoID,	Var_Etiqueta, Var_EtiquetaAFM 
		from CREDITOS where CreditoID = Par_CreditoID;
	SET Var_InstitFondeoID	:= IFNULL(Var_InstitFondeoID, Entero_Cero);
	SET Var_CreditoID 		:= IFNULL(Var_CreditoID, Entero_Cero);

	IF(IFNULL(Var_CreditoID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 000005;
		SET Par_ErrMen := 'El numero de credito no existe';
		LEAVE ManejoErrores;
	END IF;


	IF(Par_InstitutFondeoID != Var_InstitFondeoID) THEN
		SET Par_NumErr := 000005;
		SET Par_ErrMen := 'El numero de fondeador no corresponde al credito  esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Etiqueta = 'C') THEN
		SET Par_NumErr := 000006;
		SET Par_ErrMen := 'No es posible cambiar la etiqueta a Cedido.';
		LEAVE ManejoErrores;
	END IF;


	IF(Var_Etiqueta = 'C') THEN
		SET Par_NumErr := 000006;
		SET Par_ErrMen := 'El credito tiene etiqueta con valor cedido, no es posible cambiarla.';
		LEAVE ManejoErrores;
	END IF;

    IF(Var_EtiquetaAFM = 'C') THEN
		SET Par_NumErr := 000006;
		SET Par_ErrMen := 'El credito tiene etiqueta con valor cedido, no es posible cambiarla.';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EtiquetaAFM = Par_Etiqueta) THEN
		SET Par_NumErr := 000007;
		SET Par_ErrMen := 'El valor indicado es el actual de la etiqueta.';
		LEAVE ManejoErrores;
	END IF;
	

	SET Var_TipoFondeador	:= (select TipoFondeador from INSTITUTFONDEO WHERE InstitutFondID = Var_InstitFondeoID);
	SET Var_TipoFondeador	:= IFNULL(Var_TipoFondeador, Cadena_Vacia);
	IF(Var_TipoFondeador = Var_AdFiMa)THEN 
		UPDATE CREDITOS SET 
			EtiquetaFondeo	=  Par_Etiqueta,
			FechaEtiqueta	=  Var_FecActualiza,

			Usuario 		=	Aud_Usuario,
			FechaActual 	= 	Var_FechaSistema,
			DireccionIP 	=	Aud_DireccionIP,
			ProgramaID 		=	Aud_ProgramaID,
			Sucursal 		=	Aud_Sucursal,
			NumTransaccion 	=	Aud_NumTransaccion
		WHERE CreditoID = Par_CreditoID;
	ELSE
		UPDATE CREDITOS SET 
			EtiquetaAFM		=  Par_Etiqueta,
			FecEtiquetaAFM	=  Var_FecActualiza,

			Usuario 		=	Aud_Usuario,
			FechaActual 	= 	Var_FechaSistema,
			DireccionIP 	=	Aud_DireccionIP,
			ProgramaID 		=	Aud_ProgramaID,
			Sucursal 		=	Aud_Sucursal,
			NumTransaccion 	=	Aud_NumTransaccion
		WHERE CreditoID = Par_CreditoID;
	END IF; 
 
END ManejoErrores;

SELECT  Par_CreditoID,
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen;

END TerminaStore$$