package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import credito.bean.ActaConstitutivaGrupBean;
import credito.bean.AvalesBean;
import credito.beanWS.request.ConsultaDetallePagosRequest;
import credito.beanWS.response.ConsultaDetallePagosResponse;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ActaConstitutivaGrupDAO extends BaseDAO {

	public ActaConstitutivaGrupDAO (){
		super();
	}

	public ActaConstitutivaGrupBean ConsultaRegistroActaConsti(final ActaConstitutivaGrupBean gruposCreditosBean, int conPrincipal) {

		String query = "call ACTACONSTIGRUPREP(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(gruposCreditosBean.getGrupoID()),
				conPrincipal,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ActaConstitutivaGrupDAO.ConsultaRegistroActa",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTACONSTIGRUPREP(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActaConstitutivaGrupBean actaConstiGrupBean = new ActaConstitutivaGrupBean();


				actaConstiGrupBean.setNumReca(resultSet.getString(1));
				actaConstiGrupBean.setGaranLiq(resultSet.getString(2));
				actaConstiGrupBean.setNombrePres(resultSet.getString(3));
				actaConstiGrupBean.setNombreSecre(resultSet.getString(4));
				actaConstiGrupBean.setNombreTeso(resultSet.getString(5));
				actaConstiGrupBean.setDirecCompleta(resultSet.getString(6));
				actaConstiGrupBean.setNombreGrupo(resultSet.getString(7));
				actaConstiGrupBean.setMes(resultSet.getString(8));
				actaConstiGrupBean.setHora(resultSet.getString(9));
				actaConstiGrupBean.setAnio(resultSet.getString(10));
				actaConstiGrupBean.setDia(resultSet.getString(11));

				return actaConstiGrupBean;

			}
		});
		return matches.size() > 0 ? (ActaConstitutivaGrupBean) matches.get(0) : null;
	}

}
