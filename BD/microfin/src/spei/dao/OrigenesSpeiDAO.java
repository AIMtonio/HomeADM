package spei.dao;

import general.dao.BaseDAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import spei.bean.OrigenesSpeiBean;

public class OrigenesSpeiDAO extends BaseDAO  {

	public OrigenesSpeiDAO() {
		super();
	}
	
	/**
	 * Lista los Origenes para los Envíos de SPEI.
	 * @param origSpeiBean clase bean {@linkplain OrigenesSpeiBean}.
	 * @param tipoLista número de lista 1.
	 * @return lista de origenes.
	 * @author avelasco
	 */
	public List<OrigenesSpeiBean> listaPrincipal(OrigenesSpeiBean origSpeiBean, int tipoLista){
		String query = "call CATSPEIORIGENESLIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?);";
		Object[] parametros = {
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),

				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATSPEIORIGENESLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OrigenesSpeiBean origSpeiBean = new OrigenesSpeiBean();
				origSpeiBean.setOrigenSpeiID(resultSet.getString("OrigenSpeiID"));
				origSpeiBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return origSpeiBean;
			}
		});
		return matches;
	}
}