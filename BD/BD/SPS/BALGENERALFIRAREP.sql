-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALGENERALFIRAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALGENERALFIRAREP`;DELIMITER $$

CREATE PROCEDURE `BALGENERALFIRAREP`(
/* SP DE REPORTE PARA BALANCE GENERAL PARA LA CARTERA AGRO (FIRA) ESTE LLAMA A LOS PROCEDIMIENTOS ESPECIFICOS DE CADA CLIENTE*/
	Par_Ejercicio					INT(11),		# Numero de Ejercicio
	Par_Periodo						INT(11),		# Numero de Periodo
	Par_Fecha						DATE,			# Fecha de la Consulta (Nesesario para el Tipo de Consulta por Fecha)
	Par_TipoConsulta				CHAR(1),		# Tipo de Consulta D: Por Fecha, P: Por Periodo F: Fin de Periodo
	Par_SaldosCero					CHAR(1),		# Permite cuentas con saldos en 0

	Par_Cifras						CHAR(1),		# Establece si se mostrara los saldos en formato de miles
	Par_CCInicial					INT(11),		# Centro de Costos Inicial
	Par_CCFinal						INT(11),		# Centro de Costos Final
	Par_Salida						CHAR(1),		# Tipo de Salida S. Si N. No
	INOUT Par_NumErr				INT(11),		# Numero de Error

	INOUT Par_ErrMen				VARCHAR(400),	# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),

	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE BalanceGralFIRA			INT(11);
	DECLARE Con_CliProcEspe			VARCHAR(20);
	DECLARE SalidaSI				CHAR(1);
	DECLARE SalidaNO				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);

	-- Declaracion de variables
	DECLARE Var_CliProEsp			INT(11);
	DECLARE Var_llamada				VARCHAR(400);
	DECLARE Var_ProcPersonalizado 	VARCHAR(200);
	DECLARE Var_Control				CHAR(15);

	-- Asignacion de constantes
	SET Entero_Cero 				:= 0;
	SET Cadena_Vacia				:= '';
	SET BalanceGralFIRA				:= 14;
	SET Con_CliProcEspe				:= 'CliProcEspecifico';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BALGENERALFIRAREP');
			SET Var_Control := 'sqlException';
		END;
		/*SE OBTIENE EL NUMERO DE CLIENTE ESPECIFICO*/
		SET Var_CliProEsp			:= (SELECT ValorParametro FROM PARAMGENERALES
											WHERE LlaveParametro = Con_CliProcEspe);
		SET Var_CliProEsp			:= IFNULL(Var_CliProEsp, Entero_Cero);

		/*SE OBTIENE EL NOMBRE DEL SP*/
		SET Var_ProcPersonalizado	:=(SELECT NomProc FROM CATPROCEDIMIENTOS
											WHERE ProcedimientoID = BalanceGralFIRA
												AND	CliProEspID = Var_CliProEsp);
		SET Var_ProcPersonalizado	:= IFNULL(Var_ProcPersonalizado, Cadena_Vacia);

		/*Si el Proceso es diferente a Vacio se ejecuta la llamada al SP*/
		IF(Var_ProcPersonalizado != Cadena_Vacia) THEN
			SET Var_Llamada 	:= CONCAT(' CALL ', Var_ProcPersonalizado,' (',
											Par_Ejercicio,',',Par_Periodo,', \'',Par_Fecha,'\', \'',Par_TipoConsulta,'\', \'',Par_SaldosCero,'\', \'',
											Par_Cifras,'\',',Par_CCInicial,', ',Par_CCFinal,', ',Aud_EmpresaID,', ',Aud_Usuario,', \'',
											Aud_FechaActual,'\', \'',Aud_DireccionIP,'\', \'',Aud_ProgramaID,'\', ',Aud_Sucursal,', ',Aud_NumTransaccion,');');
			SET @Sentencia		:= (Var_Llamada);
			PREPARE EjecutaProc FROM @Sentencia;
			EXECUTE EjecutaProc;
			DEALLOCATE PREPARE EjecutaProc;
		END IF;

	END ManejoErrores;

END TerminaStore$$