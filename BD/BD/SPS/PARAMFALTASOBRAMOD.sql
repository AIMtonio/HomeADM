-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMFALTASOBRAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMFALTASOBRAMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMFALTASOBRAMOD`(
	Par_SucursalID			INT(11),
	Par_MontoMaximoSobra	DECIMAL(14,2),
	Par_MontoMaximoFalta	DECIMAL(14,2),

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr 		INT,
	INOUT	Par_ErrMen  	VARCHAR(350),

	Par_EmpresaID			INT,
	Aud_Usuario         	INT,
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)



	)
TerminaStore:BEGIN
-- DEclaracion de constantes
DECLARE Entero_Cero					INT;
DECLARE Decimal_Cero				DECIMAL;
DECLARE SalidaSI					CHAR(1);
-- AsignaciÃ³n de Constantes
SET Entero_Cero						:=0;		-- Entero Cero
SET Decimal_Cero					:=0.0;		-- Decimal Cero
SET  SalidaSI						:='S';		-- Saldia en Pantalla SI


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-PARAMFALTASOBRAMOD");
		END;

	IF (IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero )THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= "El Numero de Sucursal se encuentra Vacio";
			LEAVE ManejoErrores;
	END IF;
	IF (IFNULL(Par_MontoMaximoSobra,Decimal_Cero) = Decimal_Cero )THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= "El Monto Maximo Sobrante se encuentra vacio";
			LEAVE ManejoErrores;
	END IF;
	IF (IFNULL(Par_MontoMaximoFalta,Decimal_Cero) = Decimal_Cero )THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= "El Monto Maximo Faltante se encuentra vacio";
			LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT SucursalID
						FROM SUCURSALES
						WHERE SucursalID = Par_SucursalID)THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= "El Numero de Sucursal indicada no Existe";
			LEAVE ManejoErrores;
	END IF;
SET Aud_FechaActual	:=NOW();

	UPDATE PARAMFALTASOBRA SET
			MontoMaximoSobra	=Par_MontoMaximoSobra,
			MontoMaximoFalta	=Par_MontoMaximoFalta,

			EmpresaID			=Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE SucursalID = Par_SucursalID;

	SET Par_NumErr :=0;
	SET Par_ErrMen	:=CONCAT('Parametros Guardados Exitosamente: ', CONVERT(Par_SucursalID,CHAR));



END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			'sucursalID' AS control,
			Par_SucursalID AS consecutivo;
END IF;

END TerminaStore$$