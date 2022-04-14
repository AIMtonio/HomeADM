package crowdfunding.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import crowdfunding.bean.ConceptosCRWBean;

public class ConceptosCRWDAO extends BaseDAO{

	public ConceptosCRWDAO() {
		super();
	}

	//Lista de Conceptos de CRW
	public List listaConceptosCRW(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSCRWLIS(?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptosCRWDAO.listaConceptosCRW",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCRWLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosCRWBean conceptosCRW = new ConceptosCRWBean();
				conceptosCRW.setConceptoCRWID(String.valueOf(resultSet.getInt(1)));;
				conceptosCRW.setDescripcion(resultSet.getString(2));
				return conceptosCRW;
			}
		});
		return matches;
	}
}