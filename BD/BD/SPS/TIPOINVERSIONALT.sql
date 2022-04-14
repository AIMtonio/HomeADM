-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINVERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOINVERSIONALT`;
DELIMITER $$


CREATE PROCEDURE `TIPOINVERSIONALT`(
	Par_Descripcion     	VARCHAR(100), -- Descipcion del producto
	Par_MonedaID      		INT,      -- Tipo de Moneda
	Par_Reinversion     	VARCHAR(1),   -- Tipo de reinversion
	Par_Reinvertir      	VARCHAR(2),   -- Saldo a reinvertir
	Par_ClaveCNBV     		VARCHAR(10),  -- Clave registrada en la CNBV
	Par_ClaveCNBVAmpCred  	VARCHAR(10),    -- Clave que amapara creditos

	-- parametros nuevos para RECA
	Par_NumRegistroRECA   	VARCHAR(200), -- Numero de registro RECA
	Par_FechaInscripcion  	DATE,     -- fecha de inscripcion RECA
	Par_NombreComercial     VARCHAR(100), -- Nombre comercial

	Par_PagoPeriodico   	CHAR(1),    -- Si la Inversion se pagada Periodicamente o No

	Par_Salida        		CHAR(1),
	INOUT Par_NumErr    	INT,
	INOUT Par_ErrMen    	VARCHAR(350),
	Par_EmpresaID     		INT,

	Aud_Usuario       		INT,
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP    		VARCHAR(15),
	Aud_ProgramaID     	 	VARCHAR(50),
	Aud_Sucursal      		INT,
	Aud_NumTransaccion		BIGINT
  )

TerminaStore: BEGIN

DECLARE NumTipoInver  	INT;

DECLARE Descripcion   	VARCHAR(100);
DECLARE Entero_Cero   	INT;
DECLARE Cadena_Vacia  	CHAR(1);
DECLARE Sta_Activo    	CHAR(2);
DECLARE Var_Control   	VARCHAR(20);
DECLARE Salida_SI		CHAR(1);
DECLARE Fecha_Vacia  	 DATE;
DECLARE Var_No      	CHAR(1);

SET Descripcion   	:= '';
SET Entero_Cero   	:= 0;
SET Cadena_Vacia  	:= '';
SET Sta_Activo    	:= 'A';
SET Salida_SI     	:= 'S';
SET Fecha_Vacia     := '1900-01-01';        -- Constante Fecha vacia
SET Var_No			:= 'N';

SET Aud_FechaActual := NOW();

SET NumTipoInver  := 0;

ManejoErrores: BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr := '999';
      SET Par_ErrMen :=  CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                    'esto le ocasiona. Ref: SP-TIPOINVERSIONALT');
      SET Var_Control = 'SQLEXCEPTION' ;
    END;

	IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'La descripcion esta vacia.';
		SET Var_Control :=  'descripcion';
		LEAVE ManejoErrores;
	END IF;

	SET Par_ClaveCNBV :=  IFNULL(Par_ClaveCNBV,Cadena_Vacia);
	SET Par_ClaveCNBVAmpCred :=  IFNULL(Par_ClaveCNBVAmpCred,Cadena_Vacia);

	-- verificar so los datos referentes al RECA son nulos
	SET Par_NumRegistroRECA :=  IFNULL(Par_NumRegistroRECA,Cadena_Vacia);
	SET Par_FechaInscripcion :=  IFNULL(Par_FechaInscripcion,Fecha_Vacia);
	SET Par_NombreComercial :=  IFNULL(Par_NombreComercial,Cadena_Vacia);

	SET Par_PagoPeriodico := IFNULL(Par_PagoPeriodico, Var_No);
    SET NumTipoInver := (SELECT IFNULL(MAX(TipoInversionID),Entero_Cero) + 1 FROM CATINVERSION);

    INSERT CATINVERSION(
			TipoInversionID,	Descripcion,		FechaCreacion,			Estatus,				Reinversion,
			Reinvertir,     	MonedaId,   		NumRegistroRECA,  		FechaInscripcion, 		NombreComercial,
			ClaveCNBV,       	PagoPeriodico,  	EmpresaID,      		Usuario,      			FechaActual,
			DireccionIP,     	ProgramaID,     	Sucursal,      			NumTransaccion,   		ClaveCNBVAmpCred)
    VALUES(
			NumTipoInver,     Par_Descripcion,  	Aud_FechaActual,    	Sta_Activo,       		Par_Reinversion,
			Par_Reinvertir,   Par_MonedaID,     	Par_NumRegistroRECA, 	Par_FechaInscripcion, 	Par_NombreComercial,
            Par_ClaveCNBV,    Par_PagoPeriodico, 	Par_EmpresaID,      	Aud_Usuario,      		Aud_FechaActual,
            Aud_DireccionIP,  Aud_ProgramaID,   	Aud_Sucursal,     		Aud_NumTransaccion,   	Par_ClaveCNBVAmpCred);


    SET Par_NumErr := 0;
    SET Par_ErrMen := CONCAT("Tipo de Inversion Agregada Exitosamente: ", CONVERT(NumTipoInver, CHAR));
    SET Var_Control :=  'tipoInvercionID';

END ManejoErrores;

IF Par_Salida = Salida_SI THEN
  SELECT Par_NumErr AS NumErr,
       Par_ErrMen AS ErrMen,
       Var_Control AS control,
           IFNULL(NumTipoInver,Entero_Cero) AS consecutivo;
END IF;

END TerminaStore$$