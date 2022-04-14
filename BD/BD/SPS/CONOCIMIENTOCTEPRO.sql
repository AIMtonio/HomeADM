
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTEPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTEPRO`;

DELIMITER $$
CREATE PROCEDURE `CONOCIMIENTOCTEPRO`(
/** ACTUALIZA A PEP SI EN EL CONOCIMIENTO DEL CTE CUANDO HAY COINCIDENCIA
 ** EN LISTAS NEGRAS DE TIPO PEP CON LA ÚLTIMA CARGA DE LISTAS REALIZADA. */
	Par_TipoLista			CHAR(1),			-- N: Listas Negras B: Listas de Personas Bloqueadas
	Par_Masivo				CHAR(1),			-- Indica si realiza la act. masiva en conocimiento. S:Si  N:No.
	Par_FechaAltaCarga		DATE,				-- Fecha de la última carga de listas.
	Par_Salida				CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			-- Numero de Error

	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Control			VARCHAR(20);
DECLARE Var_Total			INT(11);
DECLARE Var_NumRegistro		INT(11);
DECLARE Var_ClienteID		INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE Cons_Si			CHAR(1);
DECLARE Cons_No			CHAR(1);
DECLARE EstatusActivo	CHAR(1);
DECLARE Tipo_Cliente	CHAR(3);
DECLARE Alta_ConocCTE	INT(11);
DECLARE TipoAct_PEP		INT(11);


-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';				-- Cadena Vacia.
SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia.
SET	Entero_Cero		:= 0;				-- Entero Cero.
SET Cons_Si			:= 'S';				-- Constante Si.
SET Cons_No			:= 'N';				-- Constante No.
SET EstatusActivo	:= 'A';				-- Estatus Activo.
SET Tipo_Cliente	:= 'CTE';			-- Tipo de Persona Cliente.
SET Alta_ConocCTE	:= 3;				-- Alta Conocimiento del Cliente en Histórico.
SET TipoAct_PEP		:= 1;				-- Actualización PEP en Conocimiento Cte.

SET Var_Control 		:= 'listaNegraID';
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CONOCIMIENTOCTEPRO');
		SET Var_Control:= 'sqlException';
	END;

	# SE LIMPIAN REGISTROS DE LA TABLA TMP.
	DELETE FROM TMPCLIENTESPEPLISTAS WHERE NumTransaccion = Aud_NumTransaccion;
	SET @Var_TmpPEPID := Entero_Cero;

	# SE REGISTRAN LOS CLIENTES QUE HICIERON MATCH CON LISTAS DE TIPO PEP.
	INSERT IGNORE INTO TMPCLIENTESPEPLISTAS(
		TmpPEPID,							ClienteID,			NumTransaccion)
	SELECT
		(@Var_TmpPEPID:=@Var_TmpPEPID+1),	ClavePersonaInv,	Aud_NumTransaccion
	FROM PLDDETECPERS
	WHERE TipoLista = Par_TipoLista
		AND TipoPersonaSAFI = Tipo_Cliente
		AND TipoListaID IN ('PEP','PPE','PEPINT','PPEINT')
		AND NumTransaccion = Aud_NumTransaccion
	GROUP BY ClavePersonaInv;

	# SE CUENTA EL TOTAL DE CLIENTES POR CARGA.
	SET Var_Total := (SELECT COUNT(*) FROM TMPCLIENTESPEPLISTAS WHERE NumTransaccion = Aud_NumTransaccion);
	SET Var_Total := IFNULL(Var_Total,Entero_Cero);
	SET Var_NumRegistro := 1;

	WHILE(Var_NumRegistro <= Var_Total)DO
		# SE OBTIENE EL ID DEL CLIENTE.
		SET Var_ClienteID := (SELECT ClienteID FROM TMPCLIENTESPEPLISTAS WHERE TmpPEPID = Var_NumRegistro
								AND NumTransaccion = Aud_NumTransaccion);

		# SE ACTUALIZA EL CONOCIMIENTO DEL CLIENTE.
		CALL CONOCIMIENTOCTEACT(
			Var_ClienteID,		TipoAct_PEP,		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cons_Si,		Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Entero_Cero,
			Entero_Cero,		Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Entero_Cero,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Fecha_Vacia,		Cadena_Vacia,	Entero_Cero,
			Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Entero_Cero,
			Cons_No,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_NumRegistro := Var_NumRegistro + 1;
	END WHILE;

	# SE LIMPIA TABLA TEMPORAL.
	DELETE FROM TMPCLIENTESPEPLISTAS WHERE NumTransaccion = Aud_NumTransaccion;

	SET	Par_NumErr := 0;
	SET	Par_ErrMen := CONCAT('Actualizacion Masiva PEP Exitosa.');
	SET Var_Control := 'clienteID';

END ManejoErrores;

IF (Par_Salida = Cons_Si) THEN
	SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$

