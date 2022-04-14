-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLSALDOSUCURSALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLSALDOSUCURSALALT`;DELIMITER $$

CREATE PROCEDURE `SOLSALDOSUCURSALALT`(


	Par_UsuarioID		INT(11),
	Par_SucursalID		INT(11),
	Par_CanCreDesem		INT(11),
	Par_MonCreDesem		DECIMAL(14,2),
	Par_CanInverVenci 	INT(11),
	Par_MonInverVenci	DECIMAL(14,2),
	Par_CanChequeEmi	INT(11),
	Par_MonChequeEmi	DECIMAL(14,2),
	Par_CanChequeIntReA	INT(11),
	Par_MonChequeIntReA DECIMAL(14,2),

	Par_CanChequeIntRe	INT(11),
    Par_MonChequeIntRe  DECIMAL(14,2),
	Par_SaldosCP		DECIMAL(14,2),
	Par_SaldosCA		DECIMAL(14,2),
	Par_MontoSolicitado DECIMAL(14,2),
	Par_Comentarios		VARCHAR(300),
    Par_Salida    		CHAR(1),
	INOUT	Par_NumErr 	INT(11),
	INOUT	Par_ErrMen  VARCHAR(350),
	Par_EmpresaID		INT(11),

    Aud_Usuario			INT(11),
    Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


DECLARE	Var_NumeroSol		INT(11);
DECLARE Var_FechaSolicitud	DATE;
DECLARE Var_HoraSolicitud	TIME;
DECLARE Var_Consecutivo		DECIMAL(14,2);
DECLARE VarControl	   		VARCHAR(200);


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Salida_SI			CHAR(1);


SET Var_NumeroSol			:= 0;
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET Decimal_Cero			:= 0;
SET Salida_SI				:='S';


SELECT
    FechaSistema
INTO Var_FechaSolicitud FROM
    PARAMETROSSIS;

SET Var_HoraSolicitud	:= CURTIME();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-SOLSALDOSUCURSALALT');
			SET VarControl = 'sqlException';
		END;


IF(IFNULL(Par_UsuarioID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Numero de Usuario esta Vacio';
			SET VarControl := 'usuarioID';
			LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Numero de Sucursal esta Vacio';
			SET VarControl := 'usuarioID';
			LEAVE ManejoErrores;
END IF;


IF(IFNULL(Par_MontoSolicitado,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El Monto esta Vacio';
			SET VarControl := 'montoSolicitado';
			LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_MontoSolicitado,Decimal_Cero) = Decimal_Cero ) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El Monto debe ser Mayor de Cero';
			SET VarControl := 'montoSolicitado';
			LEAVE ManejoErrores;
END IF;

SET Par_Comentarios	:= RTRIM(LTRIM(IFNULL(Par_Comentarios, Cadena_Vacia)));



CALL FOLIOSAPLICAACT('SOLSALDOSUCURSAL', Var_NumeroSol);

SET Aud_FechaActual := CURRENT_TIMESTAMP();


INSERT INTO SOLSALDOSUCURSAL (
			SolSaldoSucursalID, 	UsuarioID, 			SucursalID, 		FechaSolicitud, 	HoraSolicitud,
			CanCreDesem,			MonCreDesem, 		CanInverVenci,		MonInverVenci, 		CanChequeEmi,
			MonChequeEmi, 			CanChequeIntReA, 	MonChequeIntReA, 	CanChequeIntRe, 	MonChequeIntRe,
			SaldosCP, 				SaldosCA, 			MontoSolicitado, 	Comentarios, 		EmpresaID,
			Usuario, 				FechaActual, 		DireccionIP, 		ProgramaID, 		Sucursal,
			NumTransaccion)
		VALUES
			(Var_NumeroSol, 		Par_UsuarioID, 			Par_SucursalID, 		Var_FechaSolicitud, 	Var_HoraSolicitud,
			Par_CanCreDesem, 		Par_MonCreDesem,		Par_CanInverVenci, 		Par_MonInverVenci,		Par_CanChequeEmi,
			Par_MonChequeEmi, 		Par_CanChequeIntReA,	Par_MonChequeIntReA,	Par_CanChequeIntRe,		Par_MonChequeIntRe,
			Par_SaldosCP, 			Par_SaldosCA,			Par_MontoSolicitado, 	Par_Comentarios, 		Par_EmpresaID,
			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP, 		Aud_ProgramaID, 		Aud_Sucursal,
			Aud_NumTransaccion);


    SET Par_NumErr 		:= '000';
	SET Par_ErrMen 		:= CONCAT('Solicitud Generada con Exito por un Monto de: $',CAST(Par_MontoSolicitado AS CHAR) );
	SET VarControl		:= 'Var_NumeroSol';
	SET Var_Consecutivo	:= Par_MontoSolicitado;

	END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            VarControl AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$