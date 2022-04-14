-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIAFESTIVOPROSAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIAFESTIVOPROSAPRO`;
DELIMITER $$

CREATE PROCEDURE `DIAFESTIVOPROSAPRO`(
-- ---------------------------------------------------------------------------------
-- REGISTRA EL CONTENIDO DE LOS ARCHIVOS CARGADOS PARA ARCHIVOS EMI Y STATS
-- ---------------------------------------------------------------------------------
	Par_Fecha 				DATE,			-- Fecha a consultar
	Par_NumPro				INT(11),		-- Numero de Transaccion

    Par_Salida              CHAR(1),		-- Salida
    INOUT Par_NumErr        INT(11),		-- Salida
    INOUT Par_ErrMen        VARCHAR(400),	-- Salida

    Aud_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria

)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Fecha				DATE;				-- Numero de registros por transaccion
	DECLARE Var_FechaInhabil		DATE;				-- Fecha Inhabil de Prosa.
	DECLARE Var_Control         	VARCHAR(100);		-- Variable de control
	DECLARE Var_Continuar			CHAR(1);			-- Bandera para iteraciones
	DECLARE Var_CantFechas			INT(11);			-- Contador de fechas
	
	-- Declaracion de constantes
	DECLARE Cadena_Vacia   			VARCHAR(2);			-- Cadena vacia
	DECLARE Entero_Cero				INT(1);				-- Entero cero
	DECLARE Var_SI 					CHAR(1);			-- Salida SI
	DECLARE Var_NO					CHAR(1);			-- Salida NO
	DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE TipoArchivoEMI			CHAR(1);			-- Tipo de archivo EMI
	DECLARE TipoArchivoSTATS		CHAR(1);			-- Tipo de archivo STARTS
	DECLARE Salida_SI				CHAR(1);			-- Salida SI
	DECLARE ProGenFechas			INT(11);			-- Proceso de generacion de fechas

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';				-- Cadena vacia
	SET Entero_Cero					:= 0;				-- Entero cero
	SET Var_SI           			:= 'S';				-- Valor SI
	SET Var_NO           			:= 'N';				-- Valor NO
	SET Fecha_Vacia					:= '1900-01-01';	-- FEcha Vacia
	SET TipoArchivoEMI				:= 'E';				-- Tipo de archivo EMI
	SET TipoArchivoSTATS			:= 'S';				-- Tipo de archivo STARTS
	SET Salida_SI					:= 'S';				-- Salida SI
	SET ProGenFechas				:= 1;				-- Proceso de generacion de fechas

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr  = 999;
					SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DIAFESTIVOPROSAPRO');
				END;

		IF(Par_NumPro = ProGenFechas) THEN
			SELECT 		Fecha
				INTO 	Var_FechaInhabil
				FROM DIAFESTIVOPROSA
				WHERE Fecha = Par_Fecha;
				
			IF(IFNULL(Var_FechaInhabil, Fecha_Vacia) <> Fecha_Vacia) THEN
				SET Par_NumErr      := 1;
				SET Par_ErrMen      := CONCAT('La fecha ', Par_Fecha, ' esta parametrizada como dia inhabil.');
				SET Var_Control  	:= 'solicitudCreditoID';

				LEAVE ManejoErrores;
			END IF;
			
			
			DROP TABLE IF EXISTS TMP_FECHAARCHIVOS;
			CREATE TEMPORARY TABLE TMP_FECHAARCHIVOS (
				Fecha					DATE,
				TipoArchivo				CHAR(1),
				NombreArchivo			VARCHAR(100)
			);
			
			
			SET Var_Fecha  		:= Par_Fecha;
			SET Var_Continuar	:= Var_SI;
			
			-- Iteramos hasta encontrar el dia inhabil anterior
			WHILE Var_Continuar = Var_SI DO
				SET Var_FechaInhabil := Fecha_Vacia;
				SET	Var_Fecha	= ADDDATE(Var_Fecha, -1);

				SELECT 		Fecha
					INTO 	Var_FechaInhabil
					FROM DIAFESTIVOPROSA
					WHERE Fecha = Var_Fecha;
					
				IF(IFNULL(Var_FechaInhabil, Fecha_Vacia) = Fecha_Vacia) THEN
					SET Var_Continuar := Var_NO;
				ELSE
					INSERT INTO TMP_FECHAARCHIVOS
						SELECT Var_Fecha,		TipoArchivoEMI,		CONCAT('I1216.B0156EMI.TXS.', DATE_FORMAT(Var_Fecha, '%y%m%d'));
					SET Var_Continuar := Var_NO;
				END IF;
			END WHILE;
			
			
			SET Var_Fecha  		:= Par_Fecha;
			SET Var_Continuar	:= Var_SI;
			
			-- Iteramos hasta encontrar el dia inhabil anterior
			WHILE Var_Continuar = Var_SI DO
				SET Var_FechaInhabil := Fecha_Vacia;
				SET	Var_Fecha	= ADDDATE(Var_Fecha, -1);

				SELECT 		Fecha
					INTO 	Var_FechaInhabil
					FROM DIAFESTIVOPROSA
					WHERE Fecha = Var_Fecha;
					
				IF(IFNULL(Var_FechaInhabil, Fecha_Vacia) = Fecha_Vacia) THEN
					SET Var_Continuar := Var_NO;

					INSERT INTO TMP_FECHAARCHIVOS
						SELECT Var_Fecha,		TipoArchivoEMI,		CONCAT('I1216.B0156EMI.TXS.', DATE_FORMAT(Var_Fecha, '%y%m%d'));
				END IF;
			END WHILE;
			
			SET Var_Fecha  		:= Par_Fecha;
			SET Var_Continuar	:= Var_SI;
			
			-- Iteramos hasta encontrar el dia habil anterior
			WHILE Var_Continuar = Var_SI DO
				SET Var_FechaInhabil := Fecha_Vacia;
				SET	Var_Fecha := ADDDATE(Var_Fecha, -1);

				SELECT 		Fecha
					INTO 	Var_FechaInhabil
					FROM DIAFESTIVOPROSA
					WHERE Fecha = Var_Fecha;
					
				INSERT INTO TMP_FECHAARCHIVOS
						SELECT Var_Fecha,		TipoArchivoSTATS,	CONCAT('S7', DATE_FORMAT(Var_Fecha, '%d%m%y'),'EMV.B156');
					
				IF(IFNULL(Var_FechaInhabil, Fecha_Vacia) = Fecha_Vacia) THEN
					SET Var_Continuar := Var_NO;
				END IF;
			END WHILE;

			SET Par_NumErr := 0;
			SET Par_ErrMen := 'Registro Contenido Exitoso';
		END IF;
		
	END ManejoErrores;

   IF Par_Salida = Salida_SI THEN
		IF(Par_NumErr <> Entero_Cero) THEN
			SELECT Par_NumErr AS NumErr, Par_ErrMen AS ErrMen, Fecha_Vacia AS Fecha, Cadena_Vacia as TipoArchivo, Cadena_Vacia as NombreArchivo;
		ELSE
			SELECT Par_NumErr AS NumErr, Par_ErrMen AS ErrMen, Fecha, TipoArchivo, 	NombreArchivo
				FROM TMP_FECHAARCHIVOS;
		END IF;
    END IF;
END TerminaStore$$
 
