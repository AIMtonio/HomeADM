-- SP TMP_CARFONDEOMASIVOVAL

DELIMITER ;

DROP PROCEDURE IF EXISTS TMP_CARFONDEOMASIVOVAL;

DELIMITER $$


CREATE PROCEDURE TMP_CARFONDEOMASIVOVAL(
	-- Stored Procedure para realizar la validacion de los creditos a Fondear
	Par_TransaccionCargaID				BIGINT(20),		-- Parametro numero de transaccion

	Par_Salida							CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr					INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),		-- ID de la Empresa
	Aud_Usuario							INT(11),		-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,		-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),	-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),	-- Identificador del Programa
	Aud_Sucursal						INT(11),		-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)		-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Uno					INT(11);		-- Entero con valor uno
	DECLARE	Entero_Cero					INT(11);		-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si
	DECLARE Estatus_Error				CHAR(1);		-- 'Estatus del Cambio de Fondeo :E = Error
	DECLARE Estatus_Advertencia			CHAR(1);		-- 'Estatus del Cambio de Fondeo :A = Advertencia
	DECLARE Estatus_Valido				CHAR(1);		-- 'Estatus del Cambio de Fondeo :V = Valido
	DECLARE Estatus_Registrado			CHAR(1);		-- 'Estatus del Cambio de Fondeo :R = Registrado
	DECLARE Estatus_Pagado				CHAR(1);		-- Variable de Estatus de credito P = Pagado
	DECLARE Estatus_Castigado			CHAR(1);		-- Variable de Estatus de credito.K = Castigado
	DECLARE Etiq_FondeoCedito			CHAR(1);		-- Estatus del Fondeo: C = Cedido
	DECLARE Entero_MenosUno				INT(1);			-- Entero menos uno


	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_CreditoID				BIGINT(12);		-- Variable del numero del crédito
	DECLARE Var_ConutTras				INT(11);		-- Contador para verificar que el numero de trasacion tenga registro
	DECLARE Var_ContCredFondeo			INT(11);		-- Variable de contador de Credito a Fondear
	DECLARE Var_CantCredFondeo			INT(11);		-- Variable de  conteo de registro de los creditos cargados a fondear
	DECLARE Var_CarFondeoMavisoID		BIGINT(12);		-- Variable de ID de la tabla de registro de creditos a fondear
	DECLARE Var_InstitFondeoID			BIGINT(20);		-- Variable de ID institución de fondeo de la tabla Creditos
	DECLARE Var_InstitutFondID			INT(11);		-- Variable de ID de la institucion de Fondeo (Une con tabla INSTITUTFONDEO)
	DECLARE Var_LineaFondeoID			INT(11);		-- Variable de ID de la linea de fondeo (Une con tabla LINEAFONDEADOR)
	DECLARE Var_CreditoFondeoID			BIGINT(12);		-- Variable de ID del Credito a de pasivo para el Fondeo (Une con tabla CREDITOFONDEO)

	DECLARE Var_NumCredito				BIGINT(12);		-- Variable de numero de Cŕedito
	DECLARE Var_NumInstudFond			INT(11);		-- Variable de Numero de Institucion de fondeo
	DECLARE Var_NumLineaFondeo			INT(11);		-- Variabe de Número de linea de credito Fondeo
	DECLARE Var_Estatus					CHAR(1);		-- Variable de Estatus de credito.
	DECLARE Var_EtiquetaFondeo			CHAR(1);		-- Variable para del estatus del fondeo del credito
	DECLARE Var_ValidarEtiqCambFond		CHAR(1);		-- Variable validar la etiqueta de cambio de fondeador
	DECLARE Var_NumCredFondeo			INT(11);		-- Variable de numero de credito pasivo de fondeo
	DECLARE Var_ConsecutivoID			BIGINT(20);		-- Variable del contador de registro



	-- Asignacion de Constantes
	SET Entero_Uno						:= 1;				-- Asignacion de Entero Uno
	SET Entero_MenosUno					:= -1;				-- Asignacion de Menos Uno
	SET Entero_Cero						:= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					:= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						:= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							:= 'S';				-- Salida Si
	SET Cons_NO							:= 'N';				-- Salida Si
	SET Estatus_Error					:= 'E';				-- Estatus del Cambio de Fondeo :E = Error
	SET Estatus_Advertencia				:= 'A';				-- Estatus del Cambio de Fondeo :A = Advertencia
	SET Estatus_Valido					:= 'V';				-- Estatus del Cambio de Fondeo :V = Valido
	SET Estatus_Registrado				:= 'R';				-- Estatus del Cambio de Fondeo :R = Registrado
	SET Estatus_Pagado					:= 'P';				-- Variable de Estatus de credito P = Pagado
	SET Estatus_Castigado				:= 'K';				-- Variable de Estatus de credito.K = Castigado
	SET Etiq_FondeoCedito				:= 'C';				-- Estatus del Fondeo: C = Cedido


	-- Declaracion de Valores Default
	SET Par_TransaccionCargaID			:= IFNULL(Par_TransaccionCargaID ,Entero_Cero);

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-TMP_CARFONDEOMASIVOVAL");
		SET Var_Control = 'sqlException';
	END;

	IF(Par_TransaccionCargaID = Entero_Cero) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Numero de Transacion Esta Vacio.';
		SET Var_Control := 'transaccionCargaID';
		LEAVE ManejoErrores;
	END IF;

	SELECT COUNT(CarFondeoMavisoID)
		INTO Var_ConutTras
		FROM TMP_CARFONDEOMASIVO
		WHERE TransaccionCargaID = Par_TransaccionCargaID;

	IF(Var_ConutTras = Entero_Cero) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := CONCAT('La transaccion ', Par_TransaccionCargaID, ' no Existe o no Contiene Datos en el Archivo.');
		SET Var_Control := 'transaccionCargaID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_ConsecutivoID		:= Entero_Cero;

	SELECT MIN(CarFondeoMavisoID), MAX(CarFondeoMavisoID)
		INTO Var_ContCredFondeo,Var_CantCredFondeo
		FROM TMP_CARFONDEOMASIVO;

		-- Hacemos un loop while para ir Validando los Creditos a fondear e ir actualizandolo
		WHILE Var_ContCredFondeo <= Var_CantCredFondeo DO
			breakCliclo:BEGIN
				SET Var_InstitFondeoID		:= Entero_Cero;
				SET Var_CarFondeoMavisoID	:= Entero_Cero;
				SET Var_CreditoID			:= Entero_Cero;
				SET Var_InstitutFondID		:= Entero_Cero;
				SET Var_LineaFondeoID		:= Entero_Cero;
				SET Var_CreditoFondeoID		:= Entero_Cero;

				SELECT CarFondeoMavisoID,			CreditoID,			InstitutFondID,			LineaFondeoID,			CreditoFondeoID
					INTO Var_CarFondeoMavisoID,		Var_CreditoID,		Var_InstitutFondID,		Var_LineaFondeoID,		Var_CreditoFondeoID
					FROM TMP_CARFONDEOMASIVO
					WHERE CarFondeoMavisoID = Var_ContCredFondeo
						AND TransaccionCargaID = Par_TransaccionCargaID
						AND Estatus = Estatus_Registrado
						ORDER BY CarFondeoMavisoID ASC;

					IF(IFNULL(Var_CarFondeoMavisoID, Entero_Cero) = Entero_Cero)THEN
						LEAVE breakCliclo;
					END IF;

					-- Incrementamos el ID de la fila
					SET Var_ConsecutivoID		:= Var_ConsecutivoID + Entero_Uno;

					--  Realizamos la Validaciones correspondiente si la consulta nos devolvio registro
					-- Realizamos la validacion de que el credito exista
					SELECT CreditoID
						INTO Var_NumCredito
						FROM CREDITOS
						WHERE CreditoID = Var_CreditoID;

					IF(IFNULL(Var_NumCredito, Entero_Cero) = Entero_Cero) THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Error,
								DescripcionEstatus = 'Credito Inexistente.',
								FilaArchivo = Var_ConsecutivoID
							WHERE Estatus = Estatus_Registrado
								AND TransaccionCargaID = Par_TransaccionCargaID
								AND CreditoID = Var_CreditoID
								AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
					END IF;

					-- Realizamos la Validacion de que la Institucion de Fondeo Exista
					SELECT InstitutFondID
						INTO Var_NumInstudFond
						FROM INSTITUTFONDEO
						WHERE InstitutFondID = Var_InstitutFondID;

					IF (IFNULL(Var_NumInstudFond,Entero_MenosUno) = Entero_MenosUno) THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Error,
								DescripcionEstatus = 'Fondeador Inexistente.',
								FilaArchivo = Var_ConsecutivoID
							WHERE Estatus = Estatus_Registrado
								AND TransaccionCargaID = Par_TransaccionCargaID
								AND CreditoID = Var_CreditoID
								AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
					END IF;

					-- Realizamos la Validacion de que la Linea de Fondeo Exista
					IF (Var_LineaFondeoID > Entero_Cero)THEN
						SELECT LineaFondeoID
						INTO Var_NumLineaFondeo
						FROM LINEAFONDEADOR
						WHERE LineaFondeoID = Var_LineaFondeoID;

						IF (IFNULL(Var_NumLineaFondeo,Entero_Cero) = Entero_Cero) THEN
							UPDATE TMP_CARFONDEOMASIVO
								SET Estatus = Estatus_Error,
									DescripcionEstatus = 'Linea de Credito Inexistente.',
									FilaArchivo = Var_ConsecutivoID
								WHERE Estatus = Estatus_Registrado
									AND TransaccionCargaID = Par_TransaccionCargaID
									AND CreditoID = Var_CreditoID
									AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
							LEAVE breakCliclo;
						END IF;

					END IF;
					

					-- Realizamos la Validacion de que  el credito No se encuentre Pagado o que no se encuentre Castigado
					SELECT Estatus,	EtiquetaFondeo, InstitFondeoID
						INTO Var_Estatus, Var_EtiquetaFondeo, Var_InstitFondeoID
						FROM CREDITOS
						WHERE CreditoID = Var_CreditoID;

					SET Var_Estatus			:= IFNULL(Var_Estatus,Cadena_Vacia);
					SET Var_EtiquetaFondeo	:= IFNULL(Var_EtiquetaFondeo,Cons_NO);

					-- Validacion de credito Pagado
					IF (Var_Estatus = Estatus_Pagado) THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Error,
								DescripcionEstatus = 'Credito Pagado.',
								FilaArchivo = Var_ConsecutivoID
							WHERE Estatus = Estatus_Registrado
								AND TransaccionCargaID = Par_TransaccionCargaID
								AND CreditoID = Var_CreditoID
								AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
					END IF;

					-- Validacion de credito Castigado
					IF (Var_Estatus = Estatus_Castigado) THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Error,
								DescripcionEstatus = 'Credito Castigado.',
								FilaArchivo = Var_ConsecutivoID
							WHERE Estatus = Estatus_Registrado
								AND TransaccionCargaID = Par_TransaccionCargaID
								AND CreditoID = Var_CreditoID
								AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
					END IF;

					SELECT ValidarEtiqCambFond
						INTO Var_ValidarEtiqCambFond
						FROM PARAMETROSSIS
						LIMIT Entero_Uno;

					SET Var_ValidarEtiqCambFond		:= IFNULL(Var_ValidarEtiqCambFond,Cons_NO);

					-- Si la Etiqueta de Cambio de fondeo  esta Marcado como S= si se realiza la validación de que el credito no ha sido enviado
					IF (Var_ValidarEtiqCambFond = Cons_SI) THEN
						IF(Var_EtiquetaFondeo = Cons_NO) THEN
							UPDATE TMP_CARFONDEOMASIVO
								SET Estatus = Estatus_Error,
									DescripcionEstatus = 'Credito No Enviado.',
									FilaArchivo = Var_ConsecutivoID
								WHERE Estatus = Estatus_Registrado
									AND TransaccionCargaID = Par_TransaccionCargaID
									AND CreditoID = Var_CreditoID
									AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
						END IF;
					END IF;

					SET Var_NumLineaFondeo		:= Entero_Cero;
					SET Var_NumInstudFond		:= Entero_Cero;

					SELECT CreditoFondeoID,	LineaFondeoID,	InstitutFondID
						INTO Var_NumCredFondeo, Var_NumLineaFondeo, Var_NumInstudFond
						FROM CREDITOFONDEO
						WHERE CreditoFondeoID = Var_CreditoFondeoID;

					SET Var_NumCredFondeo	:= IFNULL(Var_NumCredFondeo,Entero_Cero);
					SET Var_NumLineaFondeo	:= IFNULL(Var_NumLineaFondeo,Entero_Cero);
					SET Var_NumInstudFond	:= IFNULL(Var_NumInstudFond,Entero_Cero);

					-- Validamos que exista el credito pasivo
					IF(Var_CreditoFondeoID > Entero_Cero) THEN
						IF (Var_NumCredFondeo = Entero_Cero) THEN
							UPDATE TMP_CARFONDEOMASIVO
								SET Estatus = Estatus_Error,
									DescripcionEstatus = 'Credito Pasivo Inexistente.',
									FilaArchivo = Var_ConsecutivoID
								WHERE Estatus = Estatus_Registrado
									AND TransaccionCargaID = Par_TransaccionCargaID
									AND CreditoID = Var_CreditoID
									AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
							LEAVE breakCliclo;
						END IF;
					END IF;
					

					IF (Var_CreditoFondeoID > Entero_Cero)THEN
						-- Validamos que la Institucion especificado fondeo sea igual a la Institucion del fondeo del Credito pasivo
						IF(Var_InstitutFondID <> Var_NumInstudFond) THEN
							UPDATE TMP_CARFONDEOMASIVO
								SET Estatus = Estatus_Error,
									DescripcionEstatus = 'Pasivo no Corresponde a Fondeador.',
									FilaArchivo = Var_ConsecutivoID
								WHERE Estatus = Estatus_Registrado
									AND TransaccionCargaID = Par_TransaccionCargaID
									AND CreditoID = Var_CreditoID
									AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
							LEAVE breakCliclo;
						END IF;

						-- Validamos que la Linea de fondeo especificado sea igual a la Linea del fondeo del Credito pasivo
						IF(Var_LineaFondeoID <> Var_NumLineaFondeo) THEN
							UPDATE TMP_CARFONDEOMASIVO
								SET Estatus = Estatus_Error,
									DescripcionEstatus = 'Pasivo no Corresponde Linea de Fondeo.',
									FilaArchivo = Var_ConsecutivoID
								WHERE Estatus = Estatus_Registrado
									AND TransaccionCargaID = Par_TransaccionCargaID
									AND CreditoID = Var_CreditoID
									AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
							LEAVE breakCliclo;
						END IF;
					END IF;

					-- Validamos que el credito  no cambie al mismo fondeador
					SET Var_NumInstudFond := Entero_Cero;
					SELECT InstitFondeoID
						INTO Var_NumInstudFond
					FROM CREDITOS
						WHERE CreditoID = Var_CreditoID;

					IF(Var_NumInstudFond = Var_InstitutFondID)THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Advertencia,
								DescripcionEstatus = 'Crédito sin afectación.',
								FilaArchivo = Var_ConsecutivoID
							WHERE Estatus = Estatus_Registrado
								AND TransaccionCargaID = Par_TransaccionCargaID
								AND CreditoID = Var_CreditoID
								AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
					END IF;

					-- Validamos si el credito ya se encuentra cedido
					IF (Var_EtiquetaFondeo = Etiq_FondeoCedito) THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Advertencia,
								DescripcionEstatus = 'Credito Actualmente Cedido.',
								FilaArchivo = Var_ConsecutivoID
							WHERE Estatus = Estatus_Registrado
								AND TransaccionCargaID = Par_TransaccionCargaID
								AND CreditoID = Var_CreditoID
								AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
						LEAVE breakCliclo;
					END IF;

					-- Validamos que el credito no sea pagado con recurso propio
					IF(Var_CreditoFondeoID = Entero_Cero) THEN
						UPDATE TMP_CARFONDEOMASIVO
							SET Estatus = Estatus_Advertencia,
								DescripcionEstatus = 'Desetiquetado de crédito.',
								FilaArchivo = Var_ConsecutivoID
						WHERE Estatus = Estatus_Registrado
							AND TransaccionCargaID = Par_TransaccionCargaID
							AND CreditoID = Var_CreditoID
							AND CarFondeoMavisoID = Var_CarFondeoMavisoID;
					END IF;

					-- Actualizamos todo los creditos que se encuentra registrado como validos 
					UPDATE TMP_CARFONDEOMASIVO
						SET Estatus = Estatus_Valido,
							DescripcionEstatus = 'Valido.',
							FilaArchivo = Var_ConsecutivoID
						WHERE Estatus = Estatus_Registrado
							AND TransaccionCargaID = Par_TransaccionCargaID
							AND CreditoID = Var_CreditoID
							AND CarFondeoMavisoID = Var_CarFondeoMavisoID;

			END breakCliclo;
            SET Var_ContCredFondeo := Var_ContCredFondeo + 1;
		END WHILE;

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Proceso Realizado Correctamente.';
		SET Var_Consecutivo	:= Par_TransaccionCargaID;
		SET Var_Control	:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_Consecutivo			AS	Consecutivo;
	END IF;
END TerminaStore$$

