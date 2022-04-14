

-- APORTDISPERSIONESACT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIONESACT`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTDISPERSIONESACT`(
/* ACTUALIZACIÓN DE DISPERSIONES EN APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_CuentaTranID			INT(11),		-- ID de la Cuenta Destino
	Par_Estatus					CHAR(1),		-- Estatus de la Dispersión.
	Par_TipoAct					TINYINT,		-- Núm. de Actualización.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No

	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE	Var_FechaSistema	CHAR(15);
DECLARE	Var_NumBenef		INT(11);
DECLARE	Var_ConBenef		CHAR(1);
DECLARE	Var_Estatus			CHAR(1);
DECLARE	Var_ParticipaSpei	CHAR(1);
DECLARE	Var_CuentaAhoID		BIGINT(12);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Cons_SI			CHAR(1);
DECLARE	Cons_NO			CHAR(1);
DECLARE	ActEstBenef		INT(11);
DECLARE	ActEstatusAp	INT(11);
DECLARE	EstatusSelec	CHAR(1);
DECLARE	EstatusPend		CHAR(1);
DECLARE Var_CuentaTranID	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET ActEstBenef			:= 01;				-- Tipo de Actualización de Beneficiarios.
SET ActEstatusAp		:= 02;				-- Tipo de Actualización Estatus de las Disp a Seleccionada.
SET	EstatusSelec		:= 'S'; 			-- Estatus Seleccionada para Dispersar.
SET	EstatusPend			:= 'P'; 			-- Estatus Pendiente por Dispersar.
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPERSIONESACT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_TipoAct,Entero_Cero)=ActEstBenef)THEN
		SET Var_NumBenef := (SELECT COUNT(*) FROM APORTBENEFICIARIOS
								WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID);
		SET Var_ConBenef := IF(IFNULL(Var_NumBenef, Entero_Cero)>Entero_Cero,Cons_SI,Cons_NO);

		UPDATE APORTDISPERSIONES
		SET
			Beneficiarios = Var_ConBenef
		WHERE AportacionID = Par_AportacionID
			AND AmortizacionID = Par_AmortizacionID;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Dispersion Actualizada Exitosamente.';
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_TipoAct,Entero_Cero) IN (ActEstatusAp))THEN
		SET Var_ParticipaSpei := (
			SELECT T.ParticipaSpei
			FROM APORTDISPERSIONES AD
				INNER JOIN CUENTASAHO C ON AD.CuentaAhoID = C.CuentaAhoID
				INNER JOIN TIPOSCUENTAS T ON C.TipoCuentaID = T.TipoCuentaID
				WHERE AD.AportacionID = Par_AportacionID AND AD.AmortizacionID = Par_AmortizacionID);

		IF(IFNULL(Par_Estatus,Cadena_Vacia)=EstatusSelec)THEN
			IF(IFNULL(Var_ParticipaSpei,Cons_NO)=Cons_NO)THEN
				SET	Par_NumErr := 1;
				SET	Par_ErrMen := 'El Tipo de Cuenta no Participa en SPEI.';
				SET Var_Control:= 'aportacionID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT CuentaTranID INTO Var_CuentaTranID
			FROM APORTDISPERSIONES 
			WHERE  AportacionID = Par_AportacionID 
			AND AmortizacionID = Par_AmortizacionID;

		SET Var_CuentaTranID := IFNULL(Var_CuentaTranID,Entero_Cero);

		IF(Var_CuentaTranID != Entero_Cero)THEN
			-- Se elimina en caso de ya estar dada de alta
			DELETE FROM APORTBENEFICIARIOS
			WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID
				AND CuentaTranID = Var_CuentaTranID;
		END IF;

		UPDATE APORTDISPERSIONES SET
			Estatus = CASE  WHEN IFNULL(Par_Estatus, '') = 'S'THEN Par_Estatus ELSE Estatus END,
			CuentaTranID = CASE  WHEN IFNULL(Par_CuentaTranID, 0)!=0 THEN Par_CuentaTranID ELSE CuentaTranID END
			WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID;



		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Dispersion(es) Actualizada(s) Exitosamente.';
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Dispersion Actualizada Exitosamente.';
	SET Var_Control:= 'aportacionID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_AportacionID AS Consecutivo;
END IF;

END TerminaStore$$