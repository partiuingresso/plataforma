function importPageModule(pageClasses, modulePath) {
	pageClasses = [].concat(pageClasses);
	for(let pageClass of pageClasses) {
		let section = document.querySelector(`.${pageClass}`);
		if(section) {
			import(/* webpackChunkName: "page-module" */ `${modulePath}`);
		}
	}
}

export default importPageModule;
