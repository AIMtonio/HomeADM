-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISTOBCAMOVILALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISTOBCAMOVILALT`;DELIMITER $$

CREATE PROCEDURE `HISTOBCAMOVILALT`(



	Par_CuentasBcaMovID	   BIGINT(20),
	Par_Estatus     	   CHAR(1),
	Par_FechaRegistro      DATETIME,

	Par_Salida			   CHAR(1),
	INOUT Par_NumErr	   INT,
	INOUT Par_ErrMen	   VARCHAR(350),

	Par_EmpresaID		   INT(11),
	Aud_Usuario			   INT(11),
	Aud_FechaActual		   DATETIME,
	Aud_DireccionIP		   VARCHAR(20),
	Aud_ProgramaID		   VARCHAR(50),
	Aud_Sucursal		   INT(11),
	Aud_NumTransaccion	   BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);


	DECLARE Var_Control	    VARCHAR(200);
	DECLARE Var_Consecutivo	BIGINT(20);
	DECLARE Var_Folio		BIGINT(20);


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01 00:00:00';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.0;
	SET Salida_SI 	   	:= 'S';
	SET	Salida_NO		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
					BEGIN
						SET Par_NumErr	= 999;
						SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-HISTOBCAMOVILALT');
						SET Var_Control	= 'sqlException';
					END;


		IF NOT EXISTS (SELECT	CuentasBcaMovID
			FROM CUENTASBCAMOVIL
			WHERE	CuentasBcaMovID = Par_CuentasBcaMovID) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('La cuenta ',Par_CuentasBcaMovID, ' no Existe');
			SET Var_Control:= 'CuentasBcaMovID' ;
			LEAVE ManejoErrores;
		END IF;


		SET Var_Folio := (SELECT IFNULL(MAX(HistoBcaMovID),Entero_Cero) + 1 FROM HISTOBCAMOVIL);

		INSERT INTO HISTOBCAMOVIL (
			HistoBcaMovID,	CuentasBcaMovID,	Estatus,		FechaRegistro,	EmpresaID,
			Usuario,    	FechaActual,   		DireccionIP,	ProgramaID,		Sucursal,
			NumTransaccion)

		VALUES(
			Var_Folio,		Par_CuentasBcaMovID,	Par_Estatus,		Par_FechaRegistro,	Par_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,	    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Alta En Historico Banca Movil Exitosamente: ", CONVERT(Par_CuentasBcaMovID, CHAR));
		SET Var_Control:= 'CuentasBcaMovID';
		SET Var_Consecutivo:= Par_CuentasBcaMovID;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Aud_NumTransaccion AS consecutivo,
					Par_ClienteID AS campoGenerico;
		END IF;

END TerminaStore$$