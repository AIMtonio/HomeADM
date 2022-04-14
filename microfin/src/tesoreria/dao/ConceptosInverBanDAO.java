package tesoreria.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import tesoreria.bean.ConceptosInverBanBean;

public class ConceptosInverBanDAO extends BaseDAO {

	public ConceptosInverBanDAO() {
		super();
	}

	public List listaConceptosInver(int tipoLista) {
		String query = "call CONCEPTOSINVBANLIS(? ,?,?,?,?,?,?,?);";
		Object[] parametros = { tipoLista,
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA, 
				Constantes.STRING_VACIO, 
				"ConceptosInverBancDAO.listaConceptosInver", 
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSINVERBANCARIALIS(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosInverBanBean conceptosInver = new ConceptosInverBanBean();
				conceptosInver.setConceptoInvBanID(String.valueOf(resultSet.getInt("ConceptoInvBanID")));
				conceptosInver.setDescripcion(resultSet.getString("Descripcion"));
				return conceptosInver;
			}
		});

		return matches;
	}

}
