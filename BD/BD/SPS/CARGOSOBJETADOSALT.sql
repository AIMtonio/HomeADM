-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOSOBJETADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOSOBJETADOSALT`;
DELIMITER $$


CREATE PROCEDURE `CARGOSOBJETADOSALT`(
	-- Stored procedure para dar de alta los registros cargos objetados.
		Par_Folio VARCHAR(12),
		Par_Periodo INT(11),
		Par_Fecha DATE,
		Par_TipoInstrumento VARCHAR(50),
		Par_InstrumentoID BIGINT(20),
		Par_Descripcion VARCHAR(200),
		Par_Cargo DECIMAL(14,2),
		Par_Abono  DECIMAL(14,2),
	
		Par_Salida						CHAR(1),				-- Parametro para salida de datos
		INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
		INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

		Aud_EmpresaID					INT(11), 				-- Parametros de auditoria
		Aud_Usuario						INT(11),				-- Parametros de auditoria
		Aud_FechaActual					DATETIME,				-- Parametros de auditoria
		Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
		Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
		Aud_Sucursal					INT(11), 				-- Parametros de auditoria
		Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)

TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_SI					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO					CHAR(1);				-- Variable con valor no

	-- Declaracion de variables
	DECLARE Var_Consecutivo			BIGINT(20); 			-- Variable consecutivo
	DECLARE Var_CargoObjID			BIGINT(20); 	

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI						:= 'S';					-- Asignacion de salida si
	SET Var_NO						:= 'N';					-- Asignacion de salida no
    SET Var_CargoObjID				:=  (SELECT IFNULL(MAX(CargoObjID),Entero_Cero)+1 FROM CARGOSOBJETADOS);

	-- Valores por default

	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGOSOBJETADOSALT');
			END;
	
        SET Aud_FechaActual := NOW();


		INSERT INTO CARGOSOBJETADOS (CargoObjID,	Folio, Periodo, Fecha, TipoInstrumento,
									InstrumentoID, Descripcion,	Cargo, Abono,	EmpresaID,
                                    Usuario,	FechaActual,	DireccionIP,	ProgramaID,		Sucursal,
                                    NumTransaccion)
			VALUES(					Var_CargoObjID,	Par_Folio,	Par_Periodo,	Par_Fecha,	UPPER(Par_TipoInstrumento),
									Par_InstrumentoID,	UPPER(Par_Descripcion),	Par_Cargo,	Par_Abono,
                                    Aud_EmpresaID,	Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
									Aud_NumTransaccion
			);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Cargos Objetados registrados correctamente';
		SET Var_Consecutivo := Var_CargoObjID;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'CargoObjID'	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$