-- SP EDOCTAV2CEDESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2CEDESPRO;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2CEDESPRO (
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);		-- Variable de Control
	DECLARE Var_AnioMes		INT(11);			-- el mes proceso

	-- Declaracion de Constantes.
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE Entero_Cero		INT(11);			-- Entero Cero
	DECLARE Var_SalidaSI	CHAR(1);			-- Salida si
	DECLARE Var_ActFolio	TINYINT UNSIGNED;	-- Actualizacion del folio generado en el estado de cuenta

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET	Var_SalidaSI		:= 'S';				-- Salida si
	SET	Var_ActFolio		:= 1;				-- Actualizacion del folio generado en el estado de cuenta

	-- Valores por default
	SET Par_EmpresaID		:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual		:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2CEDESPRO');
			SET Var_Control	= 'sqlException';
		END;


	INSERT INTO EDOCTAV2CEDES (AnioMes,		SucursalID,		ClienteID,		producto,	FechaVencimiento,
								Capital,	Gat,			Plazo	)

	SELECT TIP.Descripcion, CED.CuentaAhoID, 	CED.ClienteID,		 CED.FechaInicio,	 CED.FechaVencimiento, 
		   CED.Monto,		CED.ValorGat,		 CED.TasaNeta, 		 CONCAT(CED.Plazo,' DIAS' ) AS Plazo FROM CEDES CED INNER JOIN TIPOSCEDES TIP ON CED.TipoCedeID = TIP.TipoCedeID;

	END ManejoErrores; -- Fin del bloque manejo de errores

		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_Control			AS control,
				Par_FolioEDOCTA	AS consecutivo;
END TerminaStore$$
