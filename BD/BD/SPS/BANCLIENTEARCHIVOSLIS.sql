-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCLIENTEARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCLIENTEARCHIVOSLIS`;
DELIMITER $$


CREATE PROCEDURE `BANCLIENTEARCHIVOSLIS`(
	Par_ClienteID		INT(11),			-- ID del Cliente
	Par_ProspectoID		INT(11),			-- ID del prospecto
	Par_TipoDocumen		VARCHAR(45),		-- Tipo de Documento a Listar
	Par_TamanioLista	INT(11),			-- Parametro tamanio de la lista
	Par_PosicionInicial	INT(11),			-- Parametro posicion inicial de la lista
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(11)
		)

TerminaStore: BEGIN

	-- Declaracion de Constantes,
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Lis_Principal       INT;
	DECLARE Lis_PorCliente		INT;

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';              -- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero			:= 0;               -- Entero Cero
	SET Lis_Principal		:= 1;               -- Tipo de Lista Principal
	SET Lis_PorCliente  	:= 2;				-- Lista archivos de un cliente

	SET Par_TipoDocumen		:= IFNULL(Par_TipoDocumen, Entero_Cero);
	SET Par_TamanioLista 	:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial := IFNULL(Par_PosicionInicial, Entero_Cero);

	IF(Par_TamanioLista = Entero_Cero) THEN
		SET Par_TamanioLista	:= (SELECT COUNT(*) FROM CLIENTEARCHIVOS);
	END IF;

	-- CONSULTA POR CLIENTE
	IF(Par_NumLis = Lis_PorCliente) THEN
		DROP TABLE IF EXISTS TMP_CLIENTEARCHIVOSRESUL;
		CREATE TEMPORARY TABLE `TMP_CLIENTEARCHIVOSRESUL` (
			`ClienteID` int(11) NOT NULL COMMENT 'Numero o ID de Cliente ',
			`TipoDocumento` int(11) NOT NULL COMMENT 'Tipo de documento a digitalizar',
			`MaxConsecutivo` int(11) NOT NULL COMMENT 'Maximo consecutivo para la imagen a digitalizar\n',
			`Observacion` varchar(200) DEFAULT NULL COMMENT 'Descripcion breve referente al tipo de documento.',
			`Recurso` varchar(500) DEFAULT NULL COMMENT 'Recurso o Nombre de la Página.',
			`Instrumento` int(11) DEFAULT NULL COMMENT 'Instrumento a Tabla a que hace Referencia el \nDocumento digitalizado\nEj: SERVIFUNFOLIOS, CLIENTESPROFUN',
			`FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se digitalizo el Archivo',
			PRIMARY KEY (`ClienteID`,`TipoDocumento`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA TEMPORAL PARA RESULTADO DE LISTA';

		INSERT INTO TMP_CLIENTEARCHIVOSRESUL (
				ClienteID,	TipoDocumento,	MaxConsecutivo
		)
		SELECT	ClienteID,	TipoDocumento,	MAX(Consecutivo)
		FROM CLIENTEARCHIVOS
		WHERE ClienteID = Par_ClienteID
		GROUP BY ClienteID, TipoDocumento;

		UPDATE TMP_CLIENTEARCHIVOSRESUL T
			INNER JOIN CLIENTEARCHIVOS C
					ON C.ClienteID = T.ClienteID
					AND C.TipoDocumento = T.TipoDocumento
					AND C.Consecutivo = T.MaxConsecutivo
			SET T.Observacion = C.Observacion,
				T.Recurso = C.Recurso,
				T.Instrumento = C.Instrumento,
				T.FechaRegistro = C.FechaRegistro;

		SELECT	ClienteID,	TipoDocumento,	Observacion,	Instrumento,	FechaRegistro,
				Recurso
		FROM TMP_CLIENTEARCHIVOSRESUL
		WHERE ClienteID = Par_ClienteID
			AND TipoDocumento = IF(Par_TipoDocumen > Entero_Cero, Par_TipoDocumen, TipoDocumento)
		LIMIT Par_PosicionInicial, Par_TamanioLista;
	END IF;

END TerminaStore$$