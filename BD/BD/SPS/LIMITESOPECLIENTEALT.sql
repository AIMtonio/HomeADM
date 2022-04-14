-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMITESOPECLIENTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMITESOPECLIENTEALT`;DELIMITER $$

CREATE PROCEDURE `LIMITESOPECLIENTEALT`(



	Par_LimiteOperID		INT(11),
    Par_ClienteID			INT(11),
	Par_BancaMovil			CHAR(1),
	Par_MonMaxBcaMovil	   	DECIMAL(18,2),

	Par_Salida			   	CHAR(1),
	INOUT Par_NumErr	   	INT,
	INOUT Par_ErrMen	   	VARCHAR(350),

	Par_EmpresaID		   	INT(11),
	Aud_Usuario			   	INT(11),
	Aud_FechaActual		   	DATETIME,
	Aud_DireccionIP		   	VARCHAR(20),
	Aud_ProgramaID		   	VARCHAR(50),
	Aud_Sucursal		   	INT(11),
	Aud_NumTransaccion	   	BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
    DECLARE Est_Acti		CHAR(1);


	DECLARE Var_Control	    VARCHAR(200);
	DECLARE Var_Consecutivo	BIGINT(20);
	DECLARE Var_Folio		BIGINT(20);


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.00;
	SET Salida_SI 	   	:= 'S';
	SET	Salida_NO		:= 'N';
    SET Est_Acti		:= 'A';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-LIMITESOPECLIENTEALT');
				SET Var_Control = 'sqlException';
			END;



		IF NOT EXISTS (SELECT	CTE.ClienteID
			FROM CLIENTES CTE
			WHERE	CTE.ClienteID	= Par_ClienteID
			  AND	CTE.Estatus		= Est_Acti) THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'El cliente no Existe';
				SET Var_Control:= 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;


		IF EXISTS (SELECT	ClienteID
			FROM LIMITESOPERCLIENTE
			WHERE	ClienteID	= Par_ClienteID) THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('El Cliente ',Par_ClienteID, ' ya se Encuentra Registrado');
				SET Var_Control:= 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;



		SET Var_Folio := (SELECT IFNULL(MAX(LimiteOperID),Entero_Cero) + 1 FROM LIMITESOPERCLIENTE);

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO LIMITESOPERCLIENTE (
			LimiteOperID,	ClienteID,		BancaMovil,		MonMaxBcaMovil,	EmpresaID,
            Usuario,    	FechaActual,	DireccionIP,	ProgramaID,		Sucursal,
            NumTransaccion)

		VALUES(
			Var_Folio,		Par_ClienteID,		Par_BancaMovil,		Par_MonMaxBcaMovil,		Par_EmpresaID,
            Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
            Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Agregado(a) Exitosamente: ", CONVERT(Var_Folio, CHAR));
		SET Var_Control:= 'limiteOperID';
		SET Var_Consecutivo:= Var_Folio;


	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$