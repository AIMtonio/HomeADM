-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINVERSIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOINVERSIONMOD`;
DELIMITER $$


CREATE PROCEDURE `TIPOINVERSIONMOD`(
	Par_TipoInversionID   	INT(11),    		-- Id del producto de inversion
	Par_Descripcion     	VARCHAR(100),   	-- Descripcion del producto
	Par_MonedaID     		INT,      			-- Tipo de Moneda
	Par_Reinversion     	VARCHAR(1),   		-- Tipo de Reinversion
	Par_Reinvertir      	VARCHAR(2),   		-- Saldo a reinvertir
	-- parametros nuevos para RECA
	Par_NumRegistroRECA   	VARCHAR(200), 		-- Numero de registro RECA
	Par_FechaInscripcion  	DATE,     			-- fecha de inscripcion RECA
	Par_NombreComercial     VARCHAR(100), 		-- Nombre comercial

	Par_ClaveCNBV     		VARCHAR(10),  		-- Clave registrada en la CNBV
	Par_ClaveCNBVAmpCred  	VARCHAR(10),   		-- Clave que amapara creditos
	Par_PagoPeriodico   	CHAR(1),    		-- Paga o No Periodicamente las Inversiones

	Par_Salida        		CHAR(1),
	INOUT Par_NumErr    	INT,
	INOUT Par_ErrMen   	 	VARCHAR(350),
	Par_EmpresaID     		INT,

	Aud_Usuario       		INT,
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal      		INT,
	Aud_NumTransaccion    	BIGINT
  )

TerminaStore: BEGIN

	DECLARE NumeroTipo    			INT;
	DECLARE Cadena_Vacia  			CHAR(1);
	DECLARE Entero_Cero  			INT;
	DECLARE Var_Control   			VARCHAR(20);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Fecha_Vacia   			DATE;
	DECLARE Var_No      			CHAR(1);
    DECLARE Estatus_Inactivo		CHAR(1); 				-- Estatus Inactivo

    DECLARE Var_EstatusTipoCede		CHAR(2);			-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(45);		-- Descripcion Tipo Cede

	SET NumeroTipo    		:= 1;
	SET Cadena_Vacia  		:= '';
	SET Entero_Cero   		:= 0;
	SET Salida_SI     		:= 'S';
	SET Fecha_Vacia			:= '1900-01-01';        -- Constante Fecha vacia
	SET Var_No      		:= 'N';
	SET Estatus_Inactivo	:= 'I';

	SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	  SET Par_NumErr := '999';
	  SET Par_ErrMen :=  CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-TIPOINVERSIONMOD');
	  SET Var_Control = 'SQLEXCEPTION' ;
	END;

	SELECT	Estatus,				Descripcion
	INTO 	Var_EstatusTipoCede,	Var_Descripcion
	FROM  CATINVERSION
	WHERE TipoInversionID  = Par_TipoInversionID;

    IF(NOT EXISTS(SELECT TipoInversionID
          FROM CATINVERSION
          WHERE TipoInversionID = Par_TipoInversionID)) THEN

        SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'El Numero de Tipo de Inversion no existe.';
        SET Var_Control :=  'tipoInvercionID';
        LEAVE ManejoErrores;
    END IF;

	SET Par_ClaveCNBV :=  IFNULL(Par_ClaveCNBV,Cadena_Vacia);
	SET Par_ClaveCNBVAmpCred :=  IFNULL(Par_ClaveCNBVAmpCred,Cadena_Vacia);
	SET Par_PagoPeriodico := IFNULL(Par_PagoPeriodico, Var_No);

	-- verificar so los datos referentes al RECA son nulos
	SET Par_NumRegistroRECA :=  IFNULL(Par_NumRegistroRECA,Cadena_Vacia);
	SET Par_FechaInscripcion :=  IFNULL(Par_FechaInscripcion,Fecha_Vacia);
	SET Par_NombreComercial :=  IFNULL(Par_NombreComercial,Cadena_Vacia);

    IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
		SET Par_NumErr	:=	002;
		SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control	:=	'tipoInvercionID';
		LEAVE ManejoErrores;
	END IF;


    UPDATE CATINVERSION SET
      Descripcion   = Par_Descripcion,
      Reinversion   = Par_Reinversion,
      Reinvertir    = Par_Reinvertir,
      MonedaId    = Par_MonedaID,
            NumRegistroRECA = Par_NumRegistroRECA,
            FechaInscripcion= Par_FechaInscripcion,
            NombreComercial = Par_NombreComercial,
            ClaveCNBV   = Par_ClaveCNBV,
            ClaveCNBVAmpCred= Par_ClaveCNBVAmpCred,
            PagoPeriodico = Par_PagoPeriodico,
      EmpresaID   = Par_EmpresaID,

      Usuario     = Aud_Usuario,
      FechaActual   = Aud_FechaActual,
      DireccionIP   = Aud_DireccionIP,
      ProgramaID    = Aud_ProgramaID,
      Sucursal    = Aud_Sucursal,
      NumTransaccion  = Aud_NumTransaccion

      WHERE TipoInversionID = Par_TipoInversionID;

    SET Par_NumErr  := 0;
    SET Par_ErrMen  := 'Tipo de Inversion Modificado Exitosamente';
    SET Var_Control :=  'tipoInvercionID';

END ManejoErrores;

  IF Par_Salida = Salida_SI THEN
    SELECT Par_NumErr AS NumErr,
         Par_ErrMen AS ErrMen,
         Var_Control AS control,
               Entero_Cero AS consecutivo;
  END IF;

END TerminaStore$$