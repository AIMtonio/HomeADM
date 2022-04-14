-- BITASPEICUENTASCLABEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITASPEICUENTASCLABEPRO`;
DELIMITER $$


CREATE PROCEDURE `BITASPEICUENTASCLABEPRO`(

	Par_ClienteID			INT(11),		-- Numero del cliente
	Par_CuentaClabe			VARCHAR(18),	-- Cuenta clabe
	Par_TipoInstrumento		CHAR(2),		-- tipo de instrumento CH cuenta ahorro, CR, num. credito
	Par_Instrumento			BIGINT(12),		-- numero de instrumento
	Par_Firma				VARCHAR(1000),	-- Firma para registro de cuenta clabe

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);				-- Cadena vacia
	DECLARE Entero_Cero		INT(11);				-- Entero Cero
	DECLARE Entero_Uno		INT(11);				-- Entero Uno
	DECLARE Decimal_Cero	DECIMAL(18,2);			-- Decimal _cero
	DECLARE Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE Salida_SI		CHAR(1);				-- Salida si
	DECLARE Salida_NO		CHAR(1);				-- Salida no
	DECLARE EstInactiva		CHAR(1);				-- Estatus Inactivo
	DECLARE InstrumentoCH	CHAR(2);				-- Tipo de instrumento Cuenta Ahorro.
	DECLARE PersonalMoral	CHAR(1);				-- Tipo de persona moral
	DECLARE Var_ClienteID	INT(11);				-- ID del Cliente
	
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(200);		-- Variable de control
	DECLARE Var_FechaSis		DATE;				-- Variable para la fecha del sistema;
	DECLARE Var_TipoPersona		CHAR(1);			-- Variable de tipo de persona.
	
	
	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Entero_Uno			:= 1;
	SET Decimal_Cero		:= 0.0;					-- Decimal cero
	SET Salida_SI			:= 'S';					-- Salida SI
	SET Salida_NO			:= 'N';					-- Salida NO
	SET EstInactiva			:= 'I';					-- Estatus Inactivo
	SET InstrumentoCH		:= 'CH';				-- Tipo de instrumento Cuenta Ahorro
	SET PersonalMoral		:= 'M';					-- Tipo de persona moral
	

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-BITASPEICUENTASCLABEPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'EL numero del cliente esta vacio';
			SET Var_Control:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID 
			INTO Var_ClienteID
			FROM CLIENTES 
			WHERE ClienteID = Par_ClienteID;
		
		IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'EL cliente no existe';
			SET Var_Control:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;
		
		IF(IFNULL(Par_CuentaClabe,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La cuenta clabe esta vacio';
			SET Var_Control:= 'cuentaClabe';
			LEAVE ManejoErrores;
		END IF;
		
		IF(IFNULL(Par_Instrumento, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'La numero de instrumento esta vacio';
			SET Var_Control:= 'instrumento';
			LEAVE ManejoErrores;
		END IF;
		
		SELECT TipoPersona INTO Var_TipoPersona 
			FROM CLIENTES 
			WHERE ClienteID = Par_ClienteID;
		
		IF(Var_TipoPersona = PersonalMoral) THEN
			IF(Par_TipoInstrumento = InstrumentoCH) THEN
				CALL SPEICUENTASCLABPMORALALT(
					Par_ClienteID,		Par_CuentaClabe,		Par_Instrumento,		Salida_NO,			Par_NumErr,
					Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
					
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		ELSE
			CALL SPEICUENTASCLABEPFISICAPRO(
				Par_ClienteID,		Par_CuentaClabe,		Par_TipoInstrumento,	Par_Instrumento,		Par_Firma,
				Entero_Uno,			Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN	
				LEAVE ManejoErrores;
			END IF;
		END IF;
		
		SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS;
		
		INSERT INTO BITASPEICUENTASCLABE(
			ClienteID,			CuentaClabe,		FechaCreacion,		TipoPersona,		TipoInstrumento,
			Instrumento,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Par_ClienteID,		Par_CuentaClabe,	Var_FechaSis,		Var_TipoPersona,	Par_TipoInstrumento,
			Par_Instrumento,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	
		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Proceso realizado exitosamente';
		SET Var_Control:= 'clienteID';
	END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control;

	END IF;

END TerminaStore$$
