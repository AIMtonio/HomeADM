-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICOBROSPROFUNALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICOBROSPROFUNALT`;DELIMITER $$

CREATE PROCEDURE `CLICOBROSPROFUNALT`(

	Par_ClienteID		int(11),
	Par_Fecha			date,
	Par_FechaCobro		date,
	Par_Monto			decimal(12,2),
	Par_MontoCobrado	decimal(12,2),

	Par_MontoPendiente	decimal(12,2),
	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT,
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID			INT,

	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,

	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE varControl 		    CHAR(15);


	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		decimal(12,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			date;
	DECLARE Cliente_Activo		CHAR(1);
	DECLARE Salida_SI			CHAR(1);


	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Cliente_Activo		:='A';
	SET Fecha_Vacia			:='1900-01-01';
	SET Salida_SI			:='S';


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';



	ManejoErrores:BEGIN


		IF(ifnull(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El numero de cliente esta vacio.';
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID=Par_ClienteID)THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El cliente NO se encuentra registrado.';
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Monto,Decimal_Cero)= Decimal_Cero) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'El monto esta Vacio.';
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := NOW();
		INSERT INTO CLICOBROSPROFUN(
			ClienteID,			Fecha,				FechaCobro,		Monto,			MontoCobrado,
			MontoPendiente,		FechaBaja,			EmpresaID,		Usuario,		FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
		VALUES(
			Par_ClienteID,		Par_Fecha,			Par_FechaCobro,	Par_Monto,		Par_MontoCobrado,
			Par_MontoPendiente,	Fecha_Vacia,		Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Cobro  registrado con exito.';
		SET varControl  := 'clienteID' ;
		LEAVE ManejoErrores;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 AS ErrMen,
				varControl		 AS control,
				Par_ClienteID	 AS consecutivo;
	end IF;

END TerminaStore$$