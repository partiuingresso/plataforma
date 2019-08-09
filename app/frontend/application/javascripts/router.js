import routes from './routes'

export default {
	init() {
		for(let route of routes) {
			importPageModule({
				pageClasses: route.page,
				modulePath: route.module
			})
		}

		function importPageModule({pageClasses, modulePath}) {
			pageClasses = [].concat(pageClasses);
			for(let pageClass of pageClasses) {
				let section = document.querySelector(`.${pageClass}`);
				if(section) {
					import(/* webpackChunkName: "page-module" */ `${modulePath}`);
				}
			}
		}
	}
}
