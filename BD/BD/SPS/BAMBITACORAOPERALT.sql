-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMBITACORAOPERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMBITACORAOPERALT`;
DELIMITER $$


CREATE PROCEDURE `BAMBITACORAOPERALT`(
-- SP QUE INSERTA UNA OPERACION DE UN USUARIO A LA BITACORA DE OPERACIONES

	Par_ClienteID		INT(11),  	-- Cliente de la banca movil
	Par_TipoOperacionID	BIGINT(20),		-- Tipo de operacion a guardar
    Par_Folio			BIGINT(20),		-- Folio de la operacion en caso de aplicar
	Par_Monto 			DECIMAL(12,2),	-- Monto de la operacion en caso de aplicar
	Par_Descripcion		VARCHAR(45),	-- Descripcion de la operacion realizada
	Par_Referencia		VARCHAR(45),	-- Referencia en caso de aplicar (pago de serv y creditos)

	Par_Salida          CHAR(1),		-- Si el store necesita una salida
    INOUT Par_NumErr    INT(11),		-- Parametro de salida con numero de error
    INOUT Par_ErrMen    VARCHAR(400),	-- Parametro de salida con el mensaje de error
	Par_EmpresaID		INT(11),		-- Campo de auditoria
	Aud_Usuario			INT(11),		-- Campo de auditoria
	Aud_FechaActual		DATETIME,		-- Campo de auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Campo de auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Campo de auditoria
	Aud_Sucursal		INT(11),		-- Campo de auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Campo de auditoria
    )

TerminaStore:BEGIN

-- Declaracion de variables
DECLARE Var_NumOperID	BIGINT(20);		-- Variable tipo de opeacion ID FROM TABLE BAMTIPOOPERACIONES
DECLARE Var_Control     VARCHAR(50);	-- Variable de control
DECLARE var_FechaHrOp	DATETIME;		-- Fecha y hora de la operacion

-- Declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);		-- Cadena vacia
DECLARE	Entero_Cero		INT;			-- Entero 0
DECLARE	Decimal_Cero	DECIMAL(12,2);	-- DECIMAL 0.0
DECLARE Salida_NO 		CHAR(1);		-- Salida NO 'N'
DECLARE Salida_SI 		CHAR(1);		-- Salida SI 'S'

-- Asignacion de constantes
SET	Cadena_Vacia		:= '';			-- Cadena Vacia
SET	Entero_Cero			:= 0;			-- Entero 0
SET	Decimal_Cero		:= 0.00;		-- DECIMAL 0.0
SET	Salida_NO			:= 'N';			-- Salida NO
SET	Salida_SI			:= 'S';			-- Salida SI
SET var_FechaHrOp		:= NOW();		-- Fecha Operacion
SET Aud_FechaActual		:= NOW();		-- Fecha de Auditoria

ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMBITACORAOPERALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

    IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El ID del Cliente esta vacia.';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	  END IF;

	  IF(IFNULL(Par_TipoOperacionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El ID del Tipo Operacion esta vacio.';
		SET Var_Control := 'tipoOperacionID';
		LEAVE ManejoErrores;
	  END IF;

	  IF(IFNULL(Par_Folio, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Folio esta vacio.';
		SET Var_Control := 'folio';
		LEAVE ManejoErrores;
	  END IF;

      IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El Monto esta vacio.';
		SET Var_Control := 'monto';
		LEAVE ManejoErrores;
	  END IF;


	  IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'La Descripcion esta vacio.';
		SET Var_Control := 'descripcion';
		LEAVE ManejoErrores;
	  END IF;

     IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := 'La Referencia esta vacio.';
		SET Var_Control := 'referencia';
		LEAVE ManejoErrores;
	  END IF;


CALL FOLIOSAPLICAACT('BAMBITACORAOPERACIONES', Var_NumOperID);

INSERT INTO BAMBITACORAOPERACIONES
	(NumeroOperacion,	ClienteID,			TipoOperacionID,		Folio,	        	FechaOperacion,
	 Monto,		    	Descripcion,		Referencia,	        	EmpresaID,			Usuario,
	 FechaActual,	    DireccionIP,		ProgramaID,	     		Sucursal,			NumTransaccion)
VALUES
	(Var_NumOperID,		Par_ClienteID,  	Par_TipoOperacionID,	Par_Folio,			var_FechaHrOp,
	Par_Monto,			Par_Descripcion,	Par_Referencia,     	Par_EmpresaID,		Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	    	Aud_Sucursal,		Aud_NumTransaccion	);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Operacion Registrada Exitosamente.';
		SET Var_Control := 'clienteID';

END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					Var_Control 	AS control,
					Var_NumOperID 	AS consecutivo;
		END IF;

END TerminaStore$$