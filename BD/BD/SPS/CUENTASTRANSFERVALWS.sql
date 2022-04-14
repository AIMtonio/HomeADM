-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASTRANSFERVALWS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASTRANSFERVALWS`;DELIMITER $$

CREATE PROCEDURE `CUENTASTRANSFERVALWS`(



	Par_ClienteID		INT(11),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT,
	INOUT Par_ErrMen	VARCHAR(350),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(100),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Var_Control		VARCHAR(200);


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE TipoExterna		CHAR(1);
	DECLARE Esta_Activa		CHAR(1);


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01 00:00:00';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.0;
	SET Salida_SI 	   	:= 'S';
	SET	Salida_NO		:= 'N';
	SET	Par_NumErr		:= 0;
	SET	Par_ErrMen		:= '';
	SET Esta_Activa		:= 'A';
	SET TipoExterna		:= 'E';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASTRANSFERVALWS');
				SET Var_Control = 'sqlException';
			END;

		IF NOT EXISTS (SELECT ClienteID
			FROM CLIENTES
			WHERE	ClienteID = Par_ClienteID)THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('El Cliente ',Par_ClienteID, ' No Exite.');
				SET Var_Control:= 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	ClienteID
			FROM CLIENTES
			WHERE	ClienteID 	= Par_ClienteID
			  AND	Estatus 	= Esta_Activa)THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'Estimado Usuario(a), su Estatus No le Permite Realizar la Operación';
				SET Var_Control:= 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	CT.CuentaTranID
			FROM CUENTASTRANSFER CT,
				INSTITUCIONESSPEI ISP
			WHERE   ISP.InstitucionID 	= CT.InstitucionID
			  AND	CT.ClienteID 		= Par_ClienteID
			  AND	CT.TipoCuenta 		= TipoExterna
			  AND	CT.Estatus  		= Esta_Activa)THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := CONCAT('El Cliente ',Par_ClienteID, ' No Tiene Cuentas Asociadas');
				SET Var_Control:= 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;

        SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Validacion Exitosa: ', CONVERT(Par_ClienteID, CHAR));
		SET Var_Control:= 'clienteID' ;


	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Aud_NumTransaccion AS consecutivo;
		END IF;

END TerminaStore$$